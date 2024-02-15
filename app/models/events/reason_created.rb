module Events
  module ReasonCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
          description String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::REASON_CREATED,
      version: 1
    )
  end
end
