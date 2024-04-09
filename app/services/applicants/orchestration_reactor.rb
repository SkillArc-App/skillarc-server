module Applicants
  class OrchestrationReactor < MessageConsumer
    def reset_for_replay
      # Can't do this yet because the applications are not totally event sourced yet
    end

    on_message Events::ApplicantScreened::V1, :sync do |event|
      applicant = Applicant.find(event.aggregate.applicant_id)
      seeker = applicant.seeker

      message_service.create!(
        job_id: applicant.job_id,
        schema: Events::ApplicantStatusUpdated::V5,
        data: {
          applicant_id: applicant.id,
          applicant_first_name: seeker.first_name,
          applicant_last_name: seeker.last_name,
          applicant_email: seeker.email,
          applicant_phone_number: seeker.phone_number,
          seeker_id: seeker.id,
          user_id: seeker.user.id,
          job_id: applicant.job_id,
          employer_name: applicant.job.employer.name,
          employment_title: applicant.job.employment_title,
          status: ApplicantStatus::StatusTypes::NEW,
          reasons: []
        },
        metadata: {
          user_id: seeker.user_id
        },
        trace_id: event.trace_id,
        version: 5
      )
    end

    on_message Commands::ScreenApplicant::V1, :sync do |event|
      message_service.create!(
        applicant_id: event.aggregate.applicant_id,
        schema: Events::ApplicantScreened::V1,
        data: Messages::Nothing,
        metadata: Messages::Nothing,
        trace_id: event.trace_id,
        version: 1
      )
    end

    on_message Events::SeekerApplied::V1, :sync do |event|
      seeker_id = event.aggregate.seeker_id
      job_id = event.data.job_id

      applicant = Applicant.find_or_initialize_by(seeker_id:, job_id:) do |a|
        a.id = SecureRandom.uuid
        a.save!
      end

      ApplicantStatus.create!(
        id: SecureRandom.uuid,
        applicant:,
        status: ApplicantStatus::StatusTypes::NEW
      )

      message_service.create!(
        applicant_id: applicant.id,
        trace_id: event.trace_id,
        schema: Commands::ScreenApplicant::V1,
        data: Messages::Nothing
      )
    end
  end
end
