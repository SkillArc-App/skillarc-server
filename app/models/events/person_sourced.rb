module Events
  module PersonSourced
    module Data
      class V1
        extend Messages::Payload

        schema do
          source_kind Either(*People::SourceKind::ALL)
          source_identifier String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PERSON_SOURCED,
      version: 1
    )
  end
end
