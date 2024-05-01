module Events
  module ReliabilityAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          reliabilities ArrayOf(Either(*Reliability::ALL))
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::RELIABILITY_ADDED,
      version: 1
    )
  end
end
