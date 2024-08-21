module People
  module Events
    module Contacted
      module Data
        class V1
          extend Core::Payload

          schema do
            from_person_id Uuid
            to_person_id Uuid
            note String
            contact_type Either(*::Contact::ContactType::ALL)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::CONTACTED,
        version: 1
      )
    end
  end
end
