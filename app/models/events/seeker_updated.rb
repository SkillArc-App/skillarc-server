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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::SEEKER_UPDATED,
      version: 1
    )
  end
end
