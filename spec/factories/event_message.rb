FactoryBot.define do
  factory :event_message do
    id { SecureRandom.uuid }
    aggregate_id { SecureRandom.uuid }
    version { 1 }
    chat_message_sent

    trait :chat_message_sent do
      event_type { Event::EventTypes::CHAT_MESSAGE_SENT }
      occurred_at { Time.zone.local(2020, 1, 1) }
      data { {} }
      metadata { {} }
    end

    trait :coach_assigned do
      event_type { Event::EventTypes::COACH_ASSIGNED }
      occurred_at { Time.zone.local(2020, 1, 1) }
      data { {} }
      metadata { {} }
    end

    trait :day_elapsed do
      event_type { Event::EventTypes::DAY_ELAPSED }
      occurred_at { Time.zone.local(2020, 1, 1) }
      data { {} }
      metadata { {} }
    end

    trait :education_experience_created do
      event_type { Event::EventTypes::EDUCATION_EXPERIENCE_CREATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :employer_created do
      event_type { Event::EventTypes::EMPLOYER_CREATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :employer_updated do
      event_type { Event::EventTypes::EMPLOYER_UPDATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :employer_invite_accepted do
      event_type { Event::EventTypes::EMPLOYER_INVITE_ACCEPTED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :met_career_coach_updated do
      event_type { Event::EventTypes::MET_CAREER_COACH_UPDATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :training_provider_invite_accepted do
      event_type { Event::EventTypes::TRAINING_PROVIDER_INVITE_ACCEPTED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :experience_created do
      event_type { Event::EventTypes::EXPERIENCE_CREATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :onboarding_complete do
      event_type { Event::EventTypes::ONBOARDING_COMPLETED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :applicant_status_updated do
      event_type { Event::EventTypes::APPLICANT_STATUS_UPDATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :job_created do
      event_type { Event::EventTypes::JOB_CREATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :job_updated do
      event_type { Event::EventTypes::JOB_UPDATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :job_saved do
      event_type { Event::EventTypes::JOB_SAVED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :job_unsaved do
      event_type { Event::EventTypes::JOB_UNSAVED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :note_added do
      event_type { Event::EventTypes::NOTE_ADDED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :note_deleted do
      event_type { Event::EventTypes::NOTE_DELETED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :note_modified do
      event_type { Event::EventTypes::NOTE_MODIFIED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :profile_created do
      event_type { Event::EventTypes::PROFILE_CREATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :role_added do
      event_type { Event::EventTypes::ROLE_ADDED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :skill_level_updated do
      event_type { Event::EventTypes::SKILL_LEVEL_UPDATED }
      data { {} }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    trait :user_created do
      event_type { Event::EventTypes::USER_CREATED }
      data { { email: "tom@blocktrainapp.com" } }
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
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
      metadata { {} }
      occurred_at { Time.zone.local(2020, 1, 1) }
    end

    initialize_with { EventMessage.new(**attributes) }
  end
end
