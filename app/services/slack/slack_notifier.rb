module Slack
  class SlackNotifier
    def initialize
      @notifier = Gateway.build
    end

    private

    attr_reader :notifier
  end
end
