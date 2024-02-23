module Messages
  UNDEFINED = Messages::Undefined.new

  module Types
    module Coaches
      EVENTS = [
        BARRIER_ADDED = 'barrier_added'.freeze,
        BARRIERS_UPDATED = 'barriers_updated'.freeze,
        COACH_ASSIGNED = 'coach_assigned'.freeze,
        JOB_RECOMMENDED = 'job_recommended'.freeze,
        LEAD_ADDED = 'lead_added'.freeze,
        NOTE_ADDED = 'note_added'.freeze,
        NOTE_MODIFIED = 'note_modified'.freeze,
        NOTE_DELETED = 'note_deleted'.freeze,
        SEEKER_CERTIFIED = 'seeker_certified'.freeze,
        SKILL_LEVEL_UPDATED = 'skill_level_updated'.freeze
      ].freeze
    end

    module Jobs
      EVENTS = [
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
    end

    module Employers
      EVENTS = [
        EMPLOYER_CREATED = 'employer_created'.freeze,
        EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted'.freeze,
        EMPLOYER_UPDATED = 'employer_updated'.freeze,
        JOB_OWNER_ASSIGNED = 'job_owner_assigned'.freeze
      ].freeze
    end

    module Seekers
      EVENTS = [
        EDUCATION_EXPERIENCE_CREATED = 'education_experience_created'.freeze,
        EDUCATION_EXPERIENCE_DELETED = 'education_experience_deleted'.freeze,
        EDUCATION_EXPERIENCE_UPDATED = 'education_experience_updated'.freeze,
        ELEVATOR_PITCH_CREATED = 'elevator_pitch_created'.freeze,
        EXPERIENCE_CREATED = 'experience_created'.freeze,
        JOB_SAVED = 'job_saved'.freeze,
        JOB_SEARCH = 'job_search'.freeze,
        JOB_UNSAVED = 'job_unsaved'.freeze,
        ONBOARDING_COMPLETED = 'onboarding_completed'.freeze,
        PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created'.freeze,
        SEEKER_CREATED = 'profile_created'.freeze,
        SEEKER_UPDATED = 'seeker_updated'.freeze,
        SEEKER_VIEWED = 'seeker_viewed'.freeze
      ].freeze
    end

    module Contact
      EVENTS = [
        SMS_SENT = 'sms_sent'.freeze,
        SMTP_SENT = 'smtp_sent'.freeze
      ].freeze

      COMMANDS = [
        SEND_SMS = 'send_sms'.freeze
      ].freeze
    end

    EVENTS = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated'.freeze,
      CHAT_CREATED = 'chat_created'.freeze,
      CHAT_MESSAGE_SENT = 'chat_message_sent'.freeze,
      DAY_ELAPSED = 'day_elapsed'.freeze,
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated'.freeze,
      NOTIFICATION_CREATED = 'notification_created'.freeze,
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read'.freeze,
      REASON_CREATED = 'reason_created'.freeze,
      SESSION_STARTED = 'session_started'.freeze,
      ROLE_ADDED = 'role_added'.freeze,
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created'.freeze,
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted'.freeze,
      USER_CREATED = 'user_created'.freeze,
      USER_UPDATED = 'user_updated'.freeze,
      *Coaches::EVENTS,
      *Jobs::EVENTS,
      *Employers::EVENTS,
      *Seekers::EVENTS,
      *Contact::EVENTS
    ].freeze

    COMMANDS = [
      *Contact::COMMANDS
    ].freeze

    ALL = [
      *EVENTS,
      *COMMANDS
    ].freeze
  end
end
