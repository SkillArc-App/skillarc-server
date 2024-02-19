class EmployerApplicantNotificationMailer < ApplicationMailer
  default from: 'admin@skillarc.com'

  def notify_employer
    @job = params[:job]
    @applicant = params[:applicant]
    owner_email = params[:owner_email]

    mail(
      to: owner_email,
      subject: "New Applicant for #{@job.employment_title} - #{@applicant.first_name} #{@applicant.last_name}"
    )
  end
end
