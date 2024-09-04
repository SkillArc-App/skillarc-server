module People
  module Commands
    module AddPersonAttribute
      module Data
        class V1
          extend Core::Payload

          schema do
            id Uuid
            attribute_id Uuid
            attribute_name String
            attribute_values ArrayOf(String)
          end
        end

        class V2
          extend Core::Payload

          schema do
            id Uuid
            attribute_id Uuid
            attribute_value_ids ArrayOf(Uuid)
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::ADD_PERSON_ATTRIBUTE,
        version: 1
      )

      V2 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V2,
        metadata: Core::Nothing,
        stream: Streams::Person,
        message_type: MessageTypes::ADD_PERSON_ATTRIBUTE,
        version: 2
      )
    end
  end
end
