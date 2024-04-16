module Events
  module BarrierUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          barriers ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.inactive(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::BARRIERS_UPDATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::BARRIERS_UPDATED,
      version: 2
    )
  end
end
