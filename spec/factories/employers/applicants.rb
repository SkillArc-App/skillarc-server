FactoryBot.define do
  factory :employers_applicant, class: 'Employers::Applicant' do
    association :job, factory: :employers_job

    status { Employers::Applicant::StatusTypes::NEW }
    applicant_id { SecureRandom.uuid }
    certified_by { "john@skillarc.com" }
    seeker_id { SecureRandom.uuid }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { Faker::PhoneNumber.phone_number }
    status_as_of { Time.current }
  end
end
