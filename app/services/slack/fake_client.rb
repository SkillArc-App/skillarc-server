module Slack
  class FakeClient
    def chat_postMessage(**kwargs); end # rubocop:disable Naming/MethodName
  end
end
