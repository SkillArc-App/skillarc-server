# frozen_string_literal: true

module MessageTypes
  module Applications
    COMMANDS = [
      SCREEN_APPLICANT = 'screen_applicant'
    ].freeze

    EVENTS = [
      APPLICANT_SCREENED = 'applicant_screened'
    ].freeze
  end

  module Qualifications
    EVENTS = [
      MASTER_SKILL_CREATED = 'master_skill_created',
      MASTER_CERTIFICATION_CREATED = 'master_certification_created'
    ].freeze

    COMMANDS = [].freeze
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
      COACH_ASSIGNMENT_WEIGHT_ADDED = 'coach_assignment_weight_added',
      COACH_REMINDER_COMPLETED = 'coach_reminder_completed',
      COACH_REMINDER_SCHEDULED = 'coach_reminder_scheduled',
      LEAD_ADDED = 'lead_added',
      PERSON_VIEWED_IN_COACHING = 'person_viewed_in_coaching',
      SEEKER_CERTIFIED = 'seeker_certified'
    ].freeze

    COMMANDS = [
      ADD_LEAD = "add_lead",
      ADD_COACH_SEEKER_REMINDER = "add_coach_seeker_reminder"
    ].freeze
  end

  module Tags
    EVENTS = [
      TAG_CREATED = 'tag_created'
    ].freeze

    COMMANDS = [].freeze
  end

  module PassReason
    EVENTS = [
      PASS_REASON_ADDED = 'pass_reason_added',
      PASS_REASON_REMOVED = 'pass_reason_removed'
    ].freeze
  end

  module Invite
    EVENTS = [
      EMPLOYER_INVITE_CREATED = 'employer_invite_created',
      EMPLOYER_INVITE_ACCEPTED = 'employer_invite_accepted',
      TRAINING_PROVIDER_INVITE_CREATED = 'training_provider_invite_created',
      TRAINING_PROVIDER_INVITE_ACCEPTED = 'training_provider_invite_accepted',
      TRAINING_PROVIDER_INVITE_USED_BY_WRONG_USER = 'training_provider_invite_used_by_wrong_user',
      EMPLOYER_INVITE_USED_BY_WRONG_USER = 'employer_invite_used_by_wrong_user'
    ].freeze

    COMMANDS = [
      CREATE_EMPLOYER_INVITE = 'create_employer_invite',
      ACCEPT_EMPLOYER_INVITE = 'accept_employer_invite',
      CREATE_TRAINING_PROVIDER_INVITE = 'create_training_provider_invite',
      ACCEPT_TRAINING_PROVIDER_INVITE = 'accept_training_provider_invite'
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

  module Employers
    COMMANDS = [
      CREATE_EMPLOYER = 'create_employer',
      UPDATE_EMPLOYER = 'update_employer'
    ].freeze

    EVENTS = [
      EMPLOYER_CREATED = 'employer_created',
      EMPLOYER_UPDATED = 'employer_updated'
    ].freeze
  end

  module Seekers
    COMMANDS = [
      ADD_SEEKER = "add_seeker"
    ].freeze

    EVENTS = [
      SEEKER_APPLIED = 'seeker_applied',
      SEEKER_ATTRIBUTE_ADDED = 'seeker_attribute_added',
      SEEKER_ATTRIBUTE_REMOVED = 'seeker_attribute_removed',
      SEEKER_CONTEXT_VIEWED = 'seeker_context_viewed',
      SEEKER_CREATED = 'seeker_created',
      SEEKER_SKILL_CREATED = 'seeker_skill_created',
      SEEKER_SKILL_DESTROYED = 'seeker_skill_destroyed',
      SEEKER_SKILL_UPDATED = 'seeker_skill_updated',
      SEEKER_UPDATED = 'seeker_updated',
      USER_BASIC_INFO_ADDED = 'user_basic_info_added'
    ].freeze
  end

  module Contact
    EVENTS = [
      MESSAGE_SENT = "message_sent",
      MESSAGE_ENQUEUED = "message_enqueued",
      SMS_MESSAGE_SENT = 'sms_sent',
      KLAVIYO_EVENT_PUSHED = "klayvio_event_pushed",
      SLACK_MESSAGE_SENT = "slack_message_sent",
      EMAIL_MESSAGE_SENT = "email_message_sent",
      SMTP_SENT = 'smtp_sent',
      CAL_WEBHOOK_RECEIVED = 'cal_webhook_received'
    ].freeze

    COMMANDS = [
      SEND_SMS_MESSAGE = 'send_sms',
      SEND_MESSAGE = "send_message",
      SEND_SLACK_MESSAGE = "send_slack_message",
      SEND_EMAIL_MESSAGE = "send_email_message",
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

  module JobSearch
    EVENTS = [
      JOB_SEARCH = 'job_search'
    ].freeze

    COMMANDS = [].freeze
  end

  module TrainingProviders
    EVENTS = [
      REFERENCE_CREATED = 'reference_created',
      REFERENCE_UPDATED = 'reference_updated',
      SEEKER_TRAINING_PROVIDER_CREATED = 'seeker_training_provider_created',
      TRAINING_PROVIDER_CREATED = 'training_provider_created',
      TRAINING_PROVIDER_PROGRAM_CREATED = 'training_provider_program_created',
      TRAINING_PROVIDER_PROGRAM_UPDATED = 'training_provider_program_updated'
    ].freeze

    COMMANDS = [
      CREATE_TRAINING_PROVIDER = 'create_training_provider',
      CREATE_TRAINING_PROVIDER_PROGRAM = 'create_training_provider_program',
      UPDATE_TRAINING_PROVIDER_PROGRAM = 'update_training_provider_program'
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
    NOTIFICATION_CREATED = 'notification_created',
    *Documents::MessageTypes::EVENTS,
    *Teams::MessageTypes::EVENTS,
    *Qualifications::EVENTS,
    *Tags::EVENTS,
    *Email::EVENTS,
    *Phone::EVENTS,
    *Applications::EVENTS,
    *Coaches::EVENTS,
    *Chats::EVENTS,
    *PassReason::EVENTS,
    *Invite::EVENTS,
    *Jobs::MessageTypes::EVENTS,
    *People::MessageTypes::EVENTS,
    *Users::MessageTypes::EVENTS,
    *Industries::MessageTypes::EVENTS,
    *Attributes::MessageTypes::EVENTS,
    *JobOrders::MessageTypes::EVENTS,
    *Screeners::MessageTypes::EVENTS,
    *Employers::EVENTS,
    *Seekers::EVENTS,
    *Contact::EVENTS,
    *JobSearch::EVENTS,
    *Infrastructure::EVENTS,
    *TestingOnly::EVENTS,
    *TrainingProviders::EVENTS
  ].freeze

  COMMANDS = [
    *Documents::MessageTypes::COMMANDS,
    *Teams::MessageTypes::COMMANDS,
    *Qualifications::COMMANDS,
    *Applications::COMMANDS,
    *Tags::COMMANDS,
    *Email::COMMANDS,
    *Employers::COMMANDS,
    *Phone::COMMANDS,
    *TrainingProviders::COMMANDS,
    *Contact::COMMANDS,
    *Chats::COMMANDS,
    *Coaches::COMMANDS,
    *Seekers::COMMANDS,
    *Invite::COMMANDS,
    *Jobs::MessageTypes::COMMANDS,
    *Users::MessageTypes::COMMANDS,
    *People::MessageTypes::COMMANDS,
    *Attributes::MessageTypes::COMMANDS,
    *Industries::MessageTypes::COMMANDS,
    *JobOrders::MessageTypes::COMMANDS,
    *Screeners::MessageTypes::COMMANDS,
    *JobSearch::COMMANDS,
    *Infrastructure::COMMANDS
  ].freeze

  ALL = [
    *EVENTS,
    *COMMANDS
  ].freeze
end
