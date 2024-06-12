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

    V1 = Messages::Schema.inactive(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ADD_NOTE,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Coaches::ADD_NOTE,
      version: 2
    )
  end
end
