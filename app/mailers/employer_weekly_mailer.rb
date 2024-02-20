class EmployerWeeklyMailer < ApplicationMailer
  default from: 'admin@skillarc.com'

  def applicants
    @employer = params[:employer]
    @recruiter = params[:recruiter]

    @new_applicants = params[:new_applicants]
    @pending_applicants = params[:pending_applicants]

    mail(
      to: @recruiter.email,
      subject: 'Weekly Applicant Summary' # rubocop:disable Rails/I18nLocaleTexts
    )
  end
end
