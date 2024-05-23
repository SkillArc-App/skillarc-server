# frozen_string_literal: true

module Messages
  UNDEFINED = Messages::Undefined.new

  ALL = [
    COMMAND = "command",
    EVENT = "event"
  ].freeze

  module Types
    module Applications
      COMMANDS = [
        SCREEN_APPLICANT = 'screen_applicant'
      ].freeze

      EVENTS = [
        APPLICANT_SCREENED = 'applicant_screened'
      ].freeze
    end

    module Attributes
      EVENTS = [
        ATTRIBUTE_CREATED = 'attribute_created',
        ATTRIBUTE_UPDATED = 'attribute_updated',
        ATTRIBUTE_DELETED = 'attribute_deleted'
      ].freeze
    end

    module Person
      EVENTS = [
        PERSON_ADDED = 'person_added',
        PERSON_ASSOCIATED_TO_USER = 'person_associated_to_user',
        PERSON_ALREADY_ASSOCIATED_TO_USER = 'person_already_associated_to_user'
      ].freeze

      COMMANDS = [
        ADD_PERSON = 'add_person'
      ].freeze
    end

    module Phone
      EVENTS = [
        PERSON_ASSOCIATED_TO_PHONE_NUMBER = 'person_associated_to_phone_number'
      ].freeze

      COMMANDS = [].freeze
    end

    module Email
      EVENTS = [
        PERSON_ASSOCIATED_TO_EMAIL = 'person_associated_to_email'
      ].freeze

      COMMANDS = [].freeze
    end

    module Coaches
      EVENTS = [
        BARRIER_ADDED = 'barrier_added',
        BARRIERS_UPDATED = 'barriers_updated',
        COACH_ADDED = 'coach_added',
        COACH_ASSIGNMENT_WEIGHT_ADDED = 'coach_assignment_weight_added',
        COACH_ASSIGNED = 'coach_assigned',
        JOB_RECOMMENDED = 'job_recommended',
        COACH_REMINDER_SCHEDULED = 'coach_reminder_scheduled',
        COACH_REMINDER_COMPLETED = 'coach_reminder_completed',
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
        ADD_COACH_SEEKER_REMINDER = "add_coach_seeker_reminder",
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
        JOB_ATTRIBUTE_CREATED = 'job_attribute_created',
        JOB_ATTRIBUTE_DESTROYED = 'job_attribute_destroyed',
        JOB_ATTRIBUTE_UPDATED = 'job_attribute_updated',
        JOB_CREATED = 'job_created',
        JOB_UPDATED = 'job_updated',
        JOB_PHOTO_CREATED = 'job_photo_created',
        JOB_PHOTO_DESTROYED = 'job_photo_destroyed',
        LEARNED_SKILL_CREATED = 'learned_skill_created',
        LEARNED_SKILL_DESTROYED = 'learned_skill_destroyed',
        JOB_TAG_CREATED = 'job_tag_created',
        JOB_TAG_DELETED = 'job_tag_deleted',
        PASS_REASON_ADDED = 'pass_reason_added',
        PASS_REASON_REMOVED = 'pass_reason_removed',
        TESTIMONIAL_CREATED = 'testimonial_created',
        TESTIMONIAL_DESTROYED = 'testimonial_destroyed'
      ].freeze
    end

    module Chats
      EVENTS = [
        CHAT_CREATED = 'chat_created',
        CHAT_MESSAGE_SENT = 'chat_message_sent',
        CHAT_READ = 'chat_read'
      ].freeze

      COMMANDS = [].freeze
    end

    module JobOrders
      EVENTS = [
        JOB_ORDER_ADDED = 'job_order_added',
        JOB_ORDER_CREATION_FAILED = 'job_order_creation_failed',
        JOB_ORDER_ORDER_COUNT_ADDED = 'job_order_order_count_added',
        JOB_ORDER_ACTIVATED = 'job_order_activated',
        JOB_ORDER_ACTIVATION_FAILED = 'job_order_activation_failed',
        JOB_ORDER_NOTE_ADDED = 'job_order_note_added',
        JOB_ORDER_NOTE_MODIFIED = 'job_order_note_modified',
        JOB_ORDER_NOTE_REMOVED = 'job_order_note_removed',
        JOB_ORDER_STALLED = 'job_order_stalled',
        JOB_ORDER_FILLED = 'job_order_filled',
        JOB_ORDER_NOT_FILLED = 'job_order_not_filled',
        JOB_ORDER_CANDIDATE_ADDED = 'job_order_candidate_added',
        JOB_ORDER_CANDIDATE_APPLIED = 'job_order_candidate_applied',
        JOB_ORDER_CANDIDATE_HIRED = 'job_order_candidate_hired',
        JOB_ORDER_CANDIDATE_RECOMMENDED = 'job_order_candidate_recommended',
        JOB_ORDER_CANDIDATE_RESCINDED = 'job_order_candidate_rescinded'
      ].freeze

      COMMANDS = [
        ADD_JOB_ORDER = 'add_job_order',
        ACTIVATE_JOB_ORDER = 'activate_job_order'
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
      COMMANDS = [
        ADD_SEEKER = "add_seeker",
        START_ONBOARDING = "start_onboarding",
        COMPLETE_ONBOARDING = 'complete_onboarding'
      ].freeze

      EVENTS = [
        BASIC_INFO_ADDED = 'user_basic_info_added',
        EDUCATION_EXPERIENCE_ADDED = 'education_experience_added',
        EDUCATION_EXPERIENCE_CREATED = 'education_experience_created',
        EDUCATION_EXPERIENCE_DELETED = 'education_experience_deleted',
        EDUCATION_EXPERIENCE_UPDATED = 'education_experience_updated',
        ELEVATOR_PITCH_CREATED = 'elevator_pitch_created',
        EXPERIENCE_ADDED = 'experience_added',
        EXPERIENCE_REMOVED = 'experience_removed',
        EXPERIENCE_CREATED = 'experience_created',
        PROFESSIONAL_INTERESTS = "professional_interests",
        SEEKER_ATTRIBUTE_ADDED = 'seeker_attribute_added',
        SEEKER_ATTRIBUTE_REMOVED = 'seeker_attribute_removed',
        JOB_SAVED = 'job_saved',
        JOB_SEARCH = 'job_search',
        JOB_UNSAVED = 'job_unsaved',
        ONBOARDING_STARTED = 'onboarding_started',
        ONBOARDING_COMPLETED = 'onboarding_completed',
        PERSONAL_EXPERIENCE_ADDED = 'personal_experience_added',
        PERSONAL_EXPERIENCE_CREATED = 'personal_experience_created',
        PERSONAL_EXPERIENCE_REMOVED = 'personal_experience_removed',
        RELIABILITY_ADDED = 'relability_added',
        SEEKER_APPLIED = 'seeker_applied',
        SEEKER_CONTEXT_VIEWED = 'seeker_context_viewed',
        PROFILE_CREATED = 'profile_created',
        SEEKER_CREATED = 'seeker_created',
        SEEKER_SKILL_CREATED = 'seeker_skill_created',
        SEEKER_SKILL_DESTROYED = 'seeker_skill_destroyed',
        SEEKER_SKILL_UPDATED = 'seeker_skill_updated',
        SEEKER_UPDATED = 'seeker_updated',
        SEEKER_VIEWED = 'seeker_viewed',
        STORY_CREATED = 'story_created',
        STORY_DESTROYED = 'story_destroyed',
        STORY_UPDATED = 'story_updated',
        ZIP_ADDED = 'zip_added'
      ].freeze
    end

    module Contact
      EVENTS = [
        CONTACT_PREFERENCE_SET = "contact_preference_set",
        MESSAGE_SENT = "message_sent",
        MESSAGE_ENQUEUED = "message_enqueued",
        SMS_MESSAGE_SENT = 'sms_sent',
        KLAVIYO_EVENT_PUSHED = "klayvio_event_pushed",
        SLACK_MESSAGE_SENT = "slack_message_sent",
        EMAIL_MESSAGE_SENT = "email_message_sent",
        SMTP_SENT = 'smtp_sent',
        CAL_WEBHOOK_RECEIVED = 'cal_webhook_received',
        SLACK_ID_ADDED = "slack_id_added"
      ].freeze

      COMMANDS = [
        SEND_SMS_MESSAGE = 'send_sms',
        SEND_MESSAGE = "send_message",
        SEND_SLACK_MESSAGE = "send_slack_message",
        SEND_EMAIL_MESSAGE = "send_email_message",
        SET_CONTACT_PREFERENCE = "set_contact_preference",
        NOTIFY_EMPLOYER_OF_APPLICANT = 'notify_employer_of_applicant',
        SEND_WEEKLY_EMPLOYER_UPDATE = 'send_weekly_employer_update'
      ].freeze
    end

    module Infrastructure
      EVENTS = [
        TASK_SCHEDULED = 'task_scheduled',
        TASK_EXECUTED = 'task_executed',
        TASK_CANCELLED = 'task_cancelled'
      ].freeze

      COMMANDS = [
        SCHEDULE_TASK = 'schedule_task',
        CANCEL_TASK = 'cancel_task'
      ].freeze
    end

    module User
      EVENTS = [
        USER_CREATED = 'user_created',
        USER_UPDATED = 'user_updated'
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

      DAY_ELAPSED = 'day_elapsed',
      MET_CAREER_COACH_UPDATED = 'met_career_coach_updated',
      NOTIFICATION_CREATED = 'notification_created',
      NOTIFICATIONS_MARKED_READ = 'notifications_marked_read',
      REASON_CREATED = 'reason_created',
      SESSION_STARTED = 'session_started',
      ROLE_ADDED = 'role_added',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted',
      *User::EVENTS,
      *Person::EVENTS,
      *Email::EVENTS,
      *Phone::EVENTS,
      *Attributes::EVENTS,
      *Applications::EVENTS,
      *Coaches::EVENTS,
      *Chats::EVENTS,
      *Jobs::EVENTS,
      *JobOrders::EVENTS,
      *Employers::EVENTS,
      *Seekers::EVENTS,
      *Contact::EVENTS,
      *Infrastructure::EVENTS,
      *TestingOnly::EVENTS
    ].freeze

    COMMANDS = [
      *Applications::COMMANDS,
      *Person::COMMANDS,
      *Email::COMMANDS,
      *Phone::COMMANDS,
      *Contact::COMMANDS,
      *Chats::COMMANDS,
      *Coaches::COMMANDS,
      *Seekers::COMMANDS,
      *JobOrders::COMMANDS,
      *Infrastructure::COMMANDS
    ].freeze

    ALL = [
      *EVENTS,
      *COMMANDS
    ].freeze
  end
end
