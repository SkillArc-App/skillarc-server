module People
  module Commands
    module Contact
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
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::CONTACT,
        version: 1
      )
    end
  end
end
