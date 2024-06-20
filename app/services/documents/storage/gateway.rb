module Documents
  module Storage
    class Gateway
      module Strategies
        ALL = [
          REAL = "real".freeze,
          DB_ONLY = "db_only".freeze
        ].freeze
      end

      SmsGatewayEnvvarNotSetError = Class.new(StandardError)

      def self.build(strategy: ENV.fetch("DOCUMENT_STORAGE_STRATEGY", nil))
        case strategy
        when Strategies::REAL
          RealCommunicator.new
        when Strategies::DB_ONLY
          DbOnlyCommunicator.new
        else
          raise SmsGatewayEnvvarNotSetError
        end
      end
    end
  end
end
