module Events
  module CareerPathDestroyed
    module Data
      class V1
        extend Core::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Job,
      message_type: MessageTypes::Jobs::CAREER_PATH_DESTROYED,
      version: 1
    )
  end
end
