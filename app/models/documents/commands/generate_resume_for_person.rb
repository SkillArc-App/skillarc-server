module Documents
  module Commands
    module GenerateResumeForPerson
      module Data
        class V1
          extend Core::Payload

          schema do
            person_id Uuid
            anonymized Bool()
            document_kind Either(*DocumentKind::ALL)
            page_limit 1..
          end
        end
      end

      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Data::V1,
        metadata: Core::RequestorMetadata::V1,
        aggregate: Aggregates::Document,
        message_type: MessageTypes::GENERATE_RESUME_FOR_PERSON,
        version: 1
      )
    end
  end
end
