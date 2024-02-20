module Contact
  class SmtpService
    def notify_employer_of_applicant(job, owner_email, applicant)
      EmployerApplicantNotificationMailer.with(job:, owner_email:, applicant:).notify_employer.deliver_now

      EventService.create!(
        event_schema: Events::SmtpSent::V1,
        aggregate_id: applicant.email,
        data: Events::SmtpSent::Data::V1.new(
          email: owner_email,
          template: EmployerApplicantNotificationMailer.class.to_s,
          template_data: {
            job: {
              employment_title: job.employment_title,
              owner_email:
            },
            applicant: {
              first_name: applicant.first_name,
              last_name: applicant.last_name,
              email: applicant.email,
              phone_number: applicant.phone_number,
              seeker_id: applicant.seeker_id
            }
          }
        )
      )
    end

    def send_weekly_employer_update(new_applicants:, pending_applicants:, employer:, recruiter:)
      EmployerWeeklyMailer.with(
        employer:,
        recruiter:,
        new_applicants:,
        pending_applicants:
      ).applicants.deliver_now

      EventService.create!(
        event_schema: Events::SmtpSent::V1,
        aggregate_id: recruiter.email,
        data: Events::SmtpSent::Data::V1.new(
          email: recruiter.email,
          template: EmployerWeeklyMailer.class.to_s,
          template_data: {
            employer: {
              name: employer.name
            },
            recruiter: {
              email: recruiter.email
            },
            new_applicants: new_applicants.map do |applicant|
              {
                first_name: applicant.first_name,
                last_name: applicant.last_name
              }
            end,
            pending_applicants: pending_applicants.map do |applicant|
              {
                first_name: applicant.first_name,
                last_name: applicant.last_name
              }
            end
          }
        )
      )
    end
  end
end
