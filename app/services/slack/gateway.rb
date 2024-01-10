module Slack
  class Gateway
    GatewayEnvvarNotSetError = Class.new(StandardError)

    def self.build
      case ENV["SLACK_GATEWAY_STRATEGY"]
      when "real"
        Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"])
      when "fake"
        FakeSlackGateway.new
      else
        raise GatewayEnvvarNotSetError
      end
    end
  end
end
