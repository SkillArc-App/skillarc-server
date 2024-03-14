module Commands
  module AssignCoach
    module Data
      class V1
        extend Messages::Payload

        schema do
          email String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ASSIGN_COACH,
      version: 1
    )
  end
end
