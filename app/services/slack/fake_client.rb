module Slack
  class FakeClient
    def chat_postMessage(**kwargs) # rubocop:disable Naming/MethodName
      Rails.logger("[Slack Message to #{kwargs[:channel]}]: #{kwargs[:text]}")
    end
  end
end
