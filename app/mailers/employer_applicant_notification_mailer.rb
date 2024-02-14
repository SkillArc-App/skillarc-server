class EmployerApplicantNotificationMailer < ApplicationMailer
  default from: 'admin@skillarc.com'

  def notify_employer(job, applicant)
    @job = job
    @applicant = applicant

    mail(to: job.owner_email, subject: 'New Applicant')
  end
end
