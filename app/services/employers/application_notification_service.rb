module Employers
  class ApplicationNotificationService < MessageConsumer
    class SendEmailParams
      include(ValueSemantics.for_attributes do
        applicant_id Uuid
        trace_id Uuid
        employment_title String
        certified_by Either(String, nil), default: nil
        applicant_first_name String
        applicant_last_name String
        applicant_seeker_id Uuid
        applicant_email String
        applicant_phone_number Either(String, nil), default: nil
        applicant_status Either(*Applicant::StatusTypes::ALL)
        seeker_id Uuid
      end)
    end

    def reset_for_replay; end

    on_message Events::SeekerCertified::V1 do |message|
      Applicant.where(seeker_id: message.aggregate_id).find_each do |applicant|
        next unless applicant.staffing?

        job = Job.find_by(job_id: applicant.job.job_id)

        send_email_params = SendEmailParams.new(
          applicant_id: applicant.applicant_id,
          trace_id: message.trace_id,
          employment_title: job.employment_title,
          certified_by: message.data.coach_email,
          applicant_first_name: applicant.first_name,
          applicant_last_name: applicant.last_name,
          applicant_seeker_id: applicant.seeker_id,
          applicant_email: applicant.email,
          applicant_phone_number: applicant.phone_number,
          applicant_status: applicant.status,
          seeker_id: applicant.seeker_id
        )

        send_email(send_email_params, job)
      end
    end

    on_message Events::ApplicantStatusUpdated::V5 do |message|
      job = Job.find_by!(job_id: message.data.job_id)
      certified_by = Seeker.find_by(seeker_id: message.data.seeker_id)&.certified_by

      return if job.staffing? && certified_by.nil?

      send_email_params = SendEmailParams.new(
        applicant_id: message.data.applicant_id,
        trace_id: message.trace_id,
        employment_title: message.data.employment_title,
        certified_by:,
        applicant_first_name: message.data.applicant_first_name,
        applicant_last_name: message.data.applicant_last_name,
        applicant_seeker_id: message.data.seeker_id,
        applicant_email: message.data.applicant_email,
        applicant_phone_number: message.data.applicant_phone_number,
        applicant_status: message.data.status,
        seeker_id: message.data.seeker_id
      )

      send_email(send_email_params, job)
    end

    def send_email(send_email_params, job)
      return unless send_email_params.applicant_status == Applicant::StatusTypes::NEW

      job.owner_emails.each do |owner_email|
        CommandService.create!(
          command_schema: Commands::NotifyEmployerOfApplicant::V1,
          applicant_id: send_email_params.applicant_id,
          trace_id: send_email_params.trace_id,
          data: Commands::NotifyEmployerOfApplicant::Data::V1.new(
            employment_title: send_email_params.employment_title,
            recepent_email: owner_email,
            certified_by: send_email_params.certified_by,
            applicant_first_name: send_email_params.applicant_first_name,
            applicant_last_name: send_email_params.applicant_last_name,
            applicant_seeker_id: send_email_params.seeker_id,
            applicant_email: send_email_params.applicant_email,
            applicant_phone_number: send_email_params.applicant_phone_number
          )
        )
      end
    end
  end
end
