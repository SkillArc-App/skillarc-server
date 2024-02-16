module Contact
  class SmtpService
    def notify_employer_of_applicant(job, owner_email, applicant)
      EmployerApplicantNotificationMailer.notify_employer(job, owner_email, applicant).deliver_now

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
  end
end
