class Event < ApplicationRecord
  module EventTypes
    ALL = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated',
      CHAT_CREATED = 'chat_created',
      CHAT_MESSAGE_SENT = 'chat_message_sent',
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
      EMPLOYER_CREATED = 'employer_created',
      EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted',
      EMPLOYER_UPDATED = 'employer_updated',
      EXPERIENCE_CREATED = 'experience_created',
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated',
      JOB_CREATED = 'job_created',
      JOB_UPDATED = 'job_updated',
      JOB_SAVED = 'job_saved',
      JOB_UNSAVED = 'job_unsaved',
      NOTIFICATION_CREATED = 'notification_created',
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read',
      ONBOARDING_COMPLETED = 'onboarding_completed',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted',
      USER_CREATED = 'user_created',
      USER_UPDATED = 'user_updated'
    ]
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }
end
