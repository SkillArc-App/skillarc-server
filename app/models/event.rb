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
    COACHES = [
      BARRIER_ADDED = 'barrier_added'.freeze,
      BARRIERS_UPDATED = 'barriers_updated'.freeze,
      COACH_ASSIGNED = 'coach_assigned'.freeze,
      JOB_RECOMMENDED = 'job_recommended'.freeze,
      LEAD_ADDED = 'lead_added'.freeze,
      NOTE_ADDED = 'note_added'.freeze,
      NOTE_MODIFIED = 'note_modified'.freeze,
      NOTE_DELETED = 'note_deleted'.freeze,
      SKILL_LEVEL_UPDATED = 'skill_level_updated'.freeze
    ].freeze

    JOBS = [
      CAREER_PATH_CREATED = 'career_path_created'.freeze,
      CAREER_PATH_UPDATED = 'career_path_updated'.freeze,
      CAREER_PATH_DESTROYED = 'career_path_destroyed'.freeze,
      DESIRED_CERTIFICATION_CREATED = 'desired_certification_created'.freeze,
      DESIRED_CERTIFICATION_DESTROYED = 'desired_certification_destroyed'.freeze,
      DESIRED_SKILL_CREATED = 'desired_skill_created'.freeze,
      DESIRED_SKILL_DESTROYED = 'desired_skill_destroyed'.freeze,
      JOB_CREATED = 'job_created'.freeze,
      JOB_UPDATED = 'job_updated'.freeze,
      JOB_PHOTO_CREATED = 'job_photo_created'.freeze,
      JOB_PHOTO_DESTROYED = 'job_photo_destroyed'.freeze,
      LEARNED_SKILL_CREATED = 'learned_skill_created'.freeze,
      LEARNED_SKILL_DESTROYED = 'learned_skill_destroyed'.freeze,
      JOB_TAG_CREATED = 'job_tag_created'.freeze,
      JOB_TAG_DELETED = 'job_tag_deleted'.freeze,
      TESTIMONIAL_CREATED = 'testimonial_created'.freeze,
      TESTIMONIAL_DESTROYED = 'testimonial_destroyed'.freeze
    ].freeze

    EMPLOYERS = [
      EMPLOYER_CREATED = 'employer_created'.freeze,
      EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted'.freeze,
      EMPLOYER_UPDATED = 'employer_updated'.freeze
    ].freeze

    ALL = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated'.freeze,
      CHAT_CREATED = 'chat_created'.freeze,
      CHAT_MESSAGE_SENT = 'chat_message_sent'.freeze,
      DAY_ELAPSED = 'day_elapsed'.freeze,
      EDUCATION_EXPERIENCE_CREATED = 'education_experience_created'.freeze,
      EDUCATION_EXPERIENCE_UPDATED = 'education_experience_updated'.freeze,
      EDUCATION_EXPERIENCE_DELETED = 'education_experience_deleted'.freeze,
      EXPERIENCE_CREATED = 'experience_created'.freeze,
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated'.freeze,
      JOB_SAVED = 'job_saved'.freeze,
      JOB_SEARCH = 'job_search'.freeze,
      JOB_UNSAVED = 'job_unsaved'.freeze,
      NOTIFICATION_CREATED = 'notification_created'.freeze,
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read'.freeze,
      ONBOARDING_COMPLETED = 'onboarding_completed'.freeze,
      PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created'.freeze,
      ROLE_ADDED = 'role_added'.freeze,
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created'.freeze,
      SEEKER_CREATED = 'profile_created'.freeze,
      SEEKER_UPDATED = 'profile_updated'.freeze,
      SMS_SENT = 'sms_sent'.freeze,
      SMTP_SENT = 'smtp_sent'.freeze,
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted'.freeze,
      USER_CREATED = 'user_created'.freeze,
      USER_UPDATED = 'user_updated'.freeze,
      *COACHES,
      *EMPLOYERS,
      *JOBS
    ].freeze
  end

  def message
    schema = EventService.get_schema(event_type:, version:)

    Events::Message.new(
      id:,
      aggregate_id:,
      event_type:,
      version:,
      data: schema.data.from_hash(data),
      metadata: schema.metadata.from_hash(metadata),
      occurred_at:
    )
  end

  def self.from_message!(message)
    create!(
      id: message.id,
      aggregate_id: message.aggregate_id,
      event_type: message.event_type,
      data: message.data.to_h,
      metadata: message.metadata.to_h,
      version: message.version,
      occurred_at: message.occurred_at
    )
  end

  validates :event_type, presence: true, inclusion: { in: EventTypes::ALL }

  private

  def aggregate_id
    self[:aggregate_id]
  end

  def event_type
    self[:event_type]
  end

  def data
    self[:data].deep_symbolize_keys
  end

  def metadata
    self[:metadata].deep_symbolize_keys
  end

  def version
    self[:version]
  end

  def occurred_at
    self[:occurred_at]
  end
end
