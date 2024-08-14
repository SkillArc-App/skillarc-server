module Industries
  module Events
    module IndustriesSet
      module Data
        class V1
          extend Core::Payload

          schema do
            industries ArrayOf(String)
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Industries,
        message_type: MessageTypes::INDUSTRIES_SET,
        version: 1
      )
    end
  end
end
