module Events
  module ExperienceRemoved
    module Data
      class V1
        extend Core::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Core::Schema.inactive(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Seeker,
      message_type: MessageTypes::Person::EXPERIENCE_REMOVED,
      version: 1
    )
    V2 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Person,
      message_type: MessageTypes::Person::EXPERIENCE_REMOVED,
      version: 2
    )
  end
end
