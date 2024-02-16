class EmployerApplicantNotificationMailer < ApplicationMailer
  default from: 'admin@skillarc.com'

  def notify_employer(job, owner_email, applicant)
    @job = job
    @applicant = applicant

    mail(to: owner_email, subject: 'New Applicant') # rubocop:disable Rails/I18nLocaleTexts
  end
end
