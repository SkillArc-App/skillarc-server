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

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Coaches::BARRIERS_UPDATED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::BARRIERS_UPDATED,
      version: 2
    )
    V3 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Coaches::BARRIERS_UPDATED,
      version: 3
    )
  end
end
