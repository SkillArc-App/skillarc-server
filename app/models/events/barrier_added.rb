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
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Coaches::BARRIER_ADDED,
      version: 1
    )
  end
end
