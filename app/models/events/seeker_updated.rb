module Events
  module SeekerUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          about Either(String, Messages::UNDEFINED), default: Messages::UNDEFINED
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::SEEKER_UPDATED,
      version: 1
    )
  end
end
