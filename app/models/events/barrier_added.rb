module Events
  module BarrierAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          barrier_id Uuid
          name String
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Coaches::BARRIER_ADDED,
      version: 1
    )
  end
end
