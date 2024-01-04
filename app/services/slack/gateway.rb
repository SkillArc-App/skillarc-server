module Slack
  class Gateway
    def self.build
      case ENV["SLACK_GATEWAY_STRATEGY"]
      when "real"
        Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"])
      when "fake"
        FakeSlackGateway.new
      end
    end
  end
end
