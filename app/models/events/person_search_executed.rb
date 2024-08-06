module Events
  module PersonSearchExecuted
    module Attribute
      class V1
        extend Core::Payload

        schema do
          id Uuid
          values ArrayOf(String)
        end
      end
    end

    module Data
      class V1
        extend Core::Payload

        schema do
          search_terms Either(String, nil)
          attributes HashOf(String => ArrayOf(String))
        end
      end

      class V2
        extend Core::Payload

        schema do
          search_terms Either(String, nil)
          attributes ArrayOf(Attribute::V1)
        end
      end
    end

    V1 = Core::Schema.inactive(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      stream: Streams::PersonSearch,
      message_type: MessageTypes::PersonSearch::PERSON_SEARCH_EXECUTED,
      version: 1
    )
    V2 = Core::Schema.inactive(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      stream: Streams::User,
      message_type: MessageTypes::PersonSearch::PERSON_SEARCH_EXECUTED,
      version: 2
    )
    V3 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V2,
      metadata: Core::Nothing,
      stream: Streams::User,
      message_type: MessageTypes::PersonSearch::PERSON_SEARCH_EXECUTED,
      version: 3
    )
  end
end
