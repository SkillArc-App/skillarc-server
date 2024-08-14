module People
  module Commands
    module RemovePersonAttribute
      module Data
        class V1
          extend Core::Payload

          schema do
            id Uuid
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::REMOVE_PERSON_ATTRIBUTE,
        version: 1
      )
    end
  end
end
