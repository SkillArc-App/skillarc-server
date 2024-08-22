# frozen_string_literal: true

module Contact
  module ContactType
    ALL = [
      EMAIL = "email",
      PHONE = "phone",
      SMS = "sms"
    ].freeze
  end

  module ContactPreference
    ALL = [
      SLACK = "slack",
      EMAIL = "email",
      SMS = "sms",
      IN_APP_NOTIFICATION = "in_app_notification",
      NONE = "none"
    ].freeze
  end

  module MessageStates
    ALL = [
      ENQUEUED = "enqueued",
      COMPLETED = "completed",
      FAILED = "failed"
    ].freeze
  end
end
