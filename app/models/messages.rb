# frozen_string_literal: true

module Messages
  UNDEFINED = Messages::Undefined.new

  module Types
    module Applications
      COMMANDS = [
        SCREEN_APPLICANT = 'screen_applicant'
      ].freeze

      EVENTS = [
        APPLICANT_SCREENED = 'applicant_screened'
      ].freeze
    end

    module Coaches
      EVENTS = [
        BARRIER_ADDED = 'barrier_added',
        BARRIERS_UPDATED = 'barriers_updated',
        COACH_ASSIGNED = 'coach_assigned',
        JOB_RECOMMENDED = 'job_recommended',
        LEAD_ADDED = 'lead_added',
        NOTE_ADDED = 'note_added',
        NOTE_MODIFIED = 'note_modified',
        NOTE_DELETED = 'note_deleted',
        SEEKER_CERTIFIED = 'seeker_certified',
        SKILL_LEVEL_UPDATED = 'skill_level_updated'
      ].freeze

      COMMANDS = [
        ADD_NOTE = "add_note",
        ADD_LEAD = "add_lead",
        ASSIGN_COACH = "assign_coach"
      ].freeze
    end

    module Jobs
      EVENTS = [
        CAREER_PATH_CREATED = 'career_path_created',
        CAREER_PATH_UPDATED = 'career_path_updated',
        CAREER_PATH_DESTROYED = 'career_path_destroyed',
        DESIRED_CERTIFICATION_CREATED = 'desired_certification_created',
        DESIRED_CERTIFICATION_DESTROYED = 'desired_certification_destroyed',
        DESIRED_SKILL_CREATED = 'desired_skill_created',
        DESIRED_SKILL_DESTROYED = 'desired_skill_destroyed',
        JOB_CREATED = 'job_created',
        JOB_UPDATED = 'job_updated',
        JOB_PHOTO_CREATED = 'job_photo_created',
        JOB_PHOTO_DESTROYED = 'job_photo_destroyed',
        LEARNED_SKILL_CREATED = 'learned_skill_created',
        LEARNED_SKILL_DESTROYED = 'learned_skill_destroyed',
        JOB_TAG_CREATED = 'job_tag_created',
        JOB_TAG_DELETED = 'job_tag_deleted',
        TESTIMONIAL_CREATED = 'testimonial_created',
        TESTIMONIAL_DESTROYED = 'testimonial_destroyed'
      ].freeze
    end

    module Employers
      EVENTS = [
        EMPLOYER_CREATED = 'employer_created',
        EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted',
        EMPLOYER_UPDATED = 'employer_updated',
        JOB_OWNER_ASSIGNED = 'job_owner_assigned'
      ].freeze
    end

    module Seekers
      EVENTS = [
        EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
        EDUCATION_EXPERIENCE_DELETED = 'education_experience_deleted',
        EDUCATION_EXPERIENCE_UPDATED = 'education_experience_updated',
        ELEVATOR_PITCH_CREATED = 'elevator_pitch_created',
        EXPERIENCE_CREATED = 'experience_created',
        JOB_SAVED = 'job_saved',
        JOB_SEARCH = 'job_search',
        JOB_UNSAVED = 'job_unsaved',
        ONBOARDING_COMPLETED = 'onboarding_completed',
        PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
        SEEKER_APPLIED = 'seeker_applied',
        SEEKER_CONTEXT_VIEWED = 'seeker_context_viewed',
        SEEKER_CREATED = 'profile_created',
        SEEKER_SKILL_CREATED = 'seeker_skill_created',
        SEEKER_SKILL_DESTROYED = 'seeker_skill_destroyed',
        SEEKER_SKILL_UPDATED = 'seeker_skill_updated',
        SEEKER_UPDATED = 'seeker_updated',
        SEEKER_VIEWED = 'seeker_viewed',
        STORY_CREATED = 'story_created',
        STORY_DESTROYED = 'story_destroyed',
        STORY_UPDATED = 'story_updated'
      ].freeze
    end

    module Contact
      EVENTS = [
        CONTACT_PREFERENCE_SET = "contact_preference_set",
        SMS_SENT = 'sms_sent',
        SMTP_SENT = 'smtp_sent',
        CAL_WEBHOOK_RECEIVED = 'cal_webhook_received'
      ].freeze

      COMMANDS = [
        SEND_SMS = 'send_sms',
        SET_CONTACT_PREFERENCE = "set_contact_preference",
        NOTIFY_EMPLOYER_OF_APPLICANT = 'notify_employer_of_applicant',
        SEND_WEEKLY_EMPLOYER_UPDATE = 'send_weekly_employer_update'
      ].freeze
    end

    # Because our instance amount to singleton
    # if we want to test actual creating an event we need to
    # make it accurate as rspec stubing occurs _after_
    # these schemas have already been generated
    module TestingOnly
      EVENTS = [
        TEST_EVENT_TYPE_DONT_USE_OUTSIDE_OF_TEST = "test_event_type_dont_use_outside_of_test"
      ].freeze
    end

    EVENTS = [
      APPLICANT_STATUS_UPDATED = 'applicant_status_updated',
      CHAT_CREATED = 'chat_created',
      CHAT_MESSAGE_SENT = 'chat_message_sent',
      DAY_ELAPSED = 'day_elapsed',
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated',
      NOTIFICATION_CREATED = 'notification_created',
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read',
      REASON_CREATED = 'reason_created',
      SESSION_STARTED = 'session_started',
      ROLE_ADDED = 'role_added',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted',
      USER_CREATED = 'user_created',
      USER_UPDATED = 'user_updated',
      *Applications::EVENTS,
      *Coaches::EVENTS,
      *Jobs::EVENTS,
      *Employers::EVENTS,
      *Seekers::EVENTS,
      *Contact::EVENTS,
      *TestingOnly::EVENTS
    ].freeze

    COMMANDS = [
      *Applications::COMMANDS,
      *Contact::COMMANDS,
      *Coaches::COMMANDS
    ].freeze

    ALL = [
      *EVENTS,
      *COMMANDS
    ].freeze
  end
end
