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

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Contact::SLACK_ID_ADDED,
      version: 1
    )
  end
end
