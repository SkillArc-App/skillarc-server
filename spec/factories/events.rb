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

    trait :experience_created do
      event_type { Event::EventTypes::EXPERIENCE_CREATED }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end

    trait :onboarding_complete do
      event_type { Event::EventTypes::ONBOARDING_COMPLETE }
      data {{}}
      metadata {{}}
      occurred_at { Time.new(2020, 1, 1) }
    end
  end
end
