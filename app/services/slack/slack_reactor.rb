module Slack
  class SlackReactor < MessageReactor
    def initialize(client: Slack::Gateway.build, **params)
      super(**params)
      @client = client
    end

    on_message Commands::SendSlackMessage::V2 do |message|
      client.chat_postMessage(
        channel: message.data.channel,
        text: message.data.text,
        blocks: message.data.blocks,
        as_user: true
      )

      message_service.create_once_for_stream!(
        schema: ::Events::SlackMessageSent::V2,
        trace_id: message.trace_id,
        message_id: message.stream.message_id,
        data: message.data.to_h
      )
    end

    private

    attr_reader :client
  end
end
