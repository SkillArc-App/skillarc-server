module Events
  module SlackMessageSent
    module Data
      class V1
        extend Core::Payload

        schema do
          channel String
          text String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Message,
      message_type: MessageTypes::Contact::SLACK_MESSAGE_SENT,
      version: 1
    )
  end
end
