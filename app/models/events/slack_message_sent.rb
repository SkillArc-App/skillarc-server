module Events
  module SlackMessageSent
    module Data
      class V1
        extend Messages::Payload

        schema do
          channel String
          text String
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::SLACK_MESSAGE_SENT,
      version: 1
    )
  end
end
