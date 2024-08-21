module Teams
  module Commands
    module SendSlackMessage
      module Data
        class V1
          extend Core::Payload

          schema do
            message String
          end
        end

        class V2
          extend Core::Payload

          schema do
            text Either(String, nil), default: nil
            blocks Either(ArrayOf(Hash), nil), default: nil
          end

          def initialize(attributes)
            super
            raise ArgumentError unless text.present? || blocks.present?
          end
        end

        class V3
          extend Core::Payload

          schema do
            text Either(String, nil), default: nil
            blocks Either(ArrayOf(Hash), nil), default: nil
            message_id Uuid
          end

          def initialize(attributes)
            super
            raise ArgumentError unless text.present? || blocks.present?
          end
        end
      end

      V1 = Core::Schema.inactive(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::Nothing,
        stream: Streams::Team,
        message_type: MessageTypes::SEND_SLACK_MESSAGE,
        version: 1
      )
      V2 = Core::Schema.inactive(
        type: Core::COMMAND,
        data: Data::V2,
        metadata: Core::Nothing,
        stream: Streams::Team,
        message_type: MessageTypes::SEND_SLACK_MESSAGE,
        version: 2
      )
      V3 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V3,
        metadata: Core::Nothing,
        stream: Streams::Team,
        message_type: MessageTypes::SEND_SLACK_MESSAGE,
        version: 3
      )
    end
  end
end
