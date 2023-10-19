class Event < ApplicationRecord
  module EventTypes
    ALL = [
      USER_CREATED = 'user_created',
      EXPERIENCE_CREATED = 'experience_created',
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      ONBOARDING_COMPLETE = 'onboarding_complete'
    ]
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }
end
