module Events
  module SeekerUpdated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          about Either(String, Common::UNDEFINED), default: Common::UNDEFINED
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_UPDATED,
      version: 1
    )
  end
end
