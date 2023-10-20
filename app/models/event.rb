class Event < ApplicationRecord
  module EventTypes
    ALL = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated',
      USER_CREATED = 'user_created',
      EXPERIENCE_CREATED = 'experience_created',
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      ONBOARDING_COMPLETED = 'onboarding_completed'
    ]
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }
end
