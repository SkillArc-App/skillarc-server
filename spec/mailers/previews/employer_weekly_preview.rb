# Preview all emails at http://localhost:3000/rails/mailers/employer_weekly
class EmployerWeeklyPreview < ActionMailer::Preview
  def applicants
    employer = FactoryBot.build(:employers_employer, name: Faker::Company.name)
    recruiter = FactoryBot.build(:employers_recruiter, employer: @employer)

    job = FactoryBot.build(:employers_job, employer: @employer)

    new_applicants = [
      FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: "1 555 555 5555"),
      FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: "1 555 555 5555")
    ]

    pending_applicants = [
      FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: "1 555 555 5555"),
      FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: "1 555 555 5555"),
      FactoryBot.build(:employers_applicant, job:, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, phone_number: "1 555 555 5555")
    ]

    EmployerWeeklyMailer.with({ employer:, recruiter:, job:, new_applicants:, pending_applicants: }).applicants
  end
end
