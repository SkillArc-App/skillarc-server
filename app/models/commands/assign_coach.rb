module Commands
  module AssignCoach
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_email String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ASSIGN_COACH,
      version: 1
    )
  end
end
