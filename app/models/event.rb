# == Schema Information
#
# Table name: events
#
#  id           :uuid             not null, primary key
#  data         :jsonb            not null
#  event_type   :string           not null
#  metadata     :jsonb            not null
#  occurred_at  :datetime         not null
#  version      :integer          default(0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  aggregate_id :string           not null
#
# Indexes
#
#  index_events_on_aggregate_id_and_version  (aggregate_id,version)
#  index_events_on_event_type                (event_type)
#
class Event < ApplicationRecord
  module EventTypes
    ALL = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated',
      CHAT_CREATED = 'chat_created',
      CHAT_MESSAGE_SENT = 'chat_message_sent',
      COACH_ASSIGNED = 'coach_assigned',
      DAY_ELAPSED = 'day_elapsed',
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
      NOTE_ADDED = 'note_added',
      NOTE_MODIFIED = 'note_modified',
      NOTE_DELETED = 'note_deleted',
      NOTIFICATION_CREATED = 'notification_created',
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read',
      ONBOARDING_COMPLETED = 'onboarding_completed',
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
      PROFILE_CREATED = 'profile_created',
      PROFILE_UPDATED = 'profile_updated',
      ROLE_ADDED = 'role_added',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      SKILL_LEVEL_UPDATED = 'skill_level_updated',
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted',
      USER_CREATED = 'user_created',
      USER_UPDATED = 'user_updated'
    ]
  end

  def message
    EventMessage.new(
      id:,
      aggregate_id:,
      event_type:,
      version:,
      data: data.deep_symbolize_keys,
      metadata: data.deep_symbolize_keys,
      occurred_at:
    )
  end

  def self.from_message(message)
    create!(
      id: message.id,
      aggregate_id: message.aggregate_id,
      event_type: message.event_type,
      data: message.data,
      metadata: message.metadata,
      version: message.version,
      occurred_at: message.occurred_at
    )
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }
end
