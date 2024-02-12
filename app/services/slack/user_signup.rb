module Slack
  class UserSignup < SlackNotifier
    def call(message:)
      notifier.ping(
        "New user signed up: *#{message.data[:email]}*"
      )
    end
  end
end
