module Events
  module SeekerCreated
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
          user_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_CREATED,
      version: 1
    )
  end
end
