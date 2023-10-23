FactoryBot.define do
  factory :event do
    id { SecureRandom.uuid }
    aggregate_id { SecureRandom.uuid }

    trait :user_created do
      event_type { Event::EventTypes::USER_CREATED }
      data { { email: "tom@blocktrainapp.com" } }
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :user_updated do
      event_type { Event::EventTypes::USER_UPDATED }
      data do
        {
          email: "tom@blocktrainapp.com",
          first_name: "Tom",
          last_name: "Block",
          zip: "43210"
        }
      end
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :education_experience_created do
      event_type { Event::EventTypes::EDUCATION_EXPERIENCE_CREATED }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :experience_created do
      event_type { Event::EventTypes::EXPERIENCE_CREATED }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :onboarding_complete do
      event_type { Event::EventTypes::ONBOARDING_COMPLETED }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :applicant_status_updated do
      event_type { Event::EventTypes::APPLICANT_STATUS_UPDATED }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end
  end
end
