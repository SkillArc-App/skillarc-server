FactoryBot.define do
  factory :applicant_status do
    id { SecureRandom.uuid }

    trait :new do
      status { ApplicantStatus::StatusTypes::NEW}
    end
  end
end
