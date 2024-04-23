module Events
  module SeekerContextViewed
    module Data
      class V1
        extend Messages::Payload

        schema do
          context_id String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coach,
      message_type: Messages::Types::Seekers::SEEKER_CONTEXT_VIEWED,
      version: 1
    )
  end
end
