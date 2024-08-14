module Industries
  module Commands
    module SetIndustries
      module Data
        class V1
          extend Core::Payload

          schema do
            industries ArrayOf(String)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Industries,
        message_type: MessageTypes::SET_INDUSTRIES,
        version: 1
      )
    end
  end
end
