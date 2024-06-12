module Events
  module SlackIdAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          slack_id String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Contact::SLACK_ID_ADDED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Contact::SLACK_ID_ADDED,
      version: 2
    )
  end
end
