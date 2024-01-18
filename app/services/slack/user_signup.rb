module Slack
  class UserSignup < SlackNotifier
    def call(event:)
      notifier.ping(
        "New user signed up: *#{event.data[:email]}*"
      )
    end
  end
end
