FactoryBot.define do
  factory :analytics__dim_person, class: "Analytics::DimPerson" do
    kind { Analytics::DimPerson::Kind::USER }
    first_name { "Chris" }
    last_name { "Brauns" }
    phone_number { "740-333-4444" }
    email { "some@email.com" }
    person_id { SecureRandom.uuid }

    trait :lead do
      kind { Analytics::DimPerson::Kind::LEAD }
      lead_id { SecureRandom.uuid }
      lead_created_at { Time.zone.local(2022, 1, 1) }
    end

    trait :user do
      kind { Analytics::DimPerson::Kind::USER }
    end

    trait :seeker do
      kind { Analytics::DimPerson::Kind::SEEKER }
      seeker_id { SecureRandom.uuid }
      onboarding_completed_at { Time.zone.local(2023, 2, 1) }
    end

    trait :coach do
      kind { Analytics::DimPerson::Kind::COACH }
      coach_id { SecureRandom.uuid }
    end

    trait :recruiter do
      kind { Analytics::DimPerson::Kind::RECRUITER }
    end

    trait :training_provider do
      kind { Analytics::DimPerson::Kind::TRAINING_PROVIDER }
    end
  end
end
