module Slack
  class Gateway
    GatewayEnvvarNotSetError = Class.new(StandardError)

    def self.build
      case ENV.fetch("SLACK_GATEWAY_STRATEGY", nil)
      when "real"
        Slack::Notifier.new(ENV.fetch("SLACK_WEBHOOK_URL", nil))
      when "fake"
        FakeSlackGateway.new
      else
        raise GatewayEnvvarNotSetError
      end
    end
  end
end
