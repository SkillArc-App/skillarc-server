# Preview all emails at http://localhost:3000/rails/mailers/employer_applicant_notification_mailer
class EmployerApplicantNotificationMailerPreview < ActionMailer::Preview
  def notify_employer
    employer = FactoryBot.build(:employers_employer)

    job = FactoryBot.build(:employers_job, employer:)
    applicant = FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: "applicant@skillarc.com", phone_number: "1 555 555 5555")
    owner_email = Faker::Internet.email

    EmployerApplicantNotificationMailer.with({ job:, owner_email:, applicant: }).notify_employer
  end
end
