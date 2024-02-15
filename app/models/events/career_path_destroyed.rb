module Events
  module CareerPathDestroyed
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CAREER_PATH_DESTROYED,
      version: 1
    )
  end
end
