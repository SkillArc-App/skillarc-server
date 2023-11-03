class Event < ApplicationRecord
  module EventTypes
    ALL = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated',
      EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted',
      JOB_SAVED = 'job_saved',
      JOB_UNSAVED = 'job_unsaved',
      USER_CREATED = 'user_created',
      USER_UPDATED = 'user_updated',
      EXPERIENCE_CREATED = 'experience_created',
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      ONBOARDING_COMPLETED = 'onboarding_completed'
    ]
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }
end
