module Slack
  class Client
    def initialize
      @client = Gateway.build
    end

    private

    attr_reader :client
  end
end
