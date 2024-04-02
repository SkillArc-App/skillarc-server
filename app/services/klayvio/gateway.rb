module Klayvio
  class Gateway
    GatewayEnvvarNotSetError = Class.new(StandardError)

    def self.build(strategy: ENV.fetch("KLAYVIO_GATEWAY_STRATEGY", nil), api_key: ENV.fetch("KLAYVIO_API_KEY", nil))
      case strategy
      when "real"
        RealGateway.new(api_key:)
      when "fake"
        FakeGateway.new
      else
        raise GatewayEnvvarNotSetError
      end
    end
  end
end
