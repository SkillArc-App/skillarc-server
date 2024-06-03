module Events
  module NoteDeleted
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_id Uuid
          coach_email String
          note_id Uuid
        end
      end

      class V2
        extend Messages::Payload

        schema do
          originator String
          note_id Uuid
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::NOTE_DELETED,
      version: 1
    )
    V2 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_DELETED,
      version: 2
    )
    V3 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::NOTE_DELETED,
      version: 3
    )
    V4 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Coaches::NOTE_DELETED,
      version: 4
    )
  end
end
