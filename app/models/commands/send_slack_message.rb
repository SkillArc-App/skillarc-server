module Commands
  module SendSlackMessage
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
      type: Core::COMMAND,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Message,
      message_type: MessageTypes::Contact::SEND_SLACK_MESSAGE,
      version: 1
    )
  end
end
