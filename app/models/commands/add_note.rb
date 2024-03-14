module Commands
  module AddNote
    module Data
      class V1
        extend Messages::Payload

        schema do
          originator String
          note String
          note_id Uuid
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ADD_NOTE,
      version: 1
    )
  end
end
