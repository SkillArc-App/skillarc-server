class EmployerApplicantNotificationMailer < ApplicationMailer
  default from: 'admin@skillarc.com'

  def notify_employer(job, owner_email, applicant)
    @job = job
    @applicant = applicant

    mail(
      to: owner_email,
      subject: "New Applicant for #{job.employment_title} - #{applicant.first_name} #{applicant.last_name}"
    )
  end
end
