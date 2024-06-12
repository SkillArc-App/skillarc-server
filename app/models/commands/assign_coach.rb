module Commands
  module AssignCoach
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_email String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          coach_id String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ASSIGN_COACH,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Coaches::ASSIGN_COACH,
      version: 2
    )
  end
end
