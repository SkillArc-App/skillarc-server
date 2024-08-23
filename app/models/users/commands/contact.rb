module Users
  module Commands
    module Contact
      module Data
        class V1
          extend Core::Payload

          schema do
            person_id Uuid
            note String
            contact_direction Either(*::Contact::ContactDirection::ALL)
            contact_type Either(*::Contact::ContactType::ALL)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::User,
        message_type: MessageTypes::CONTACT,
        version: 1
      )
    end
  end
end
