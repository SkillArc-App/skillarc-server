module Events
  module JobSearch
    module Data
      class V1
        extend Messages::Payload

        schema do
          search_terms Either(String, nil)
          industries Either(ArrayOf(String), nil)
          tags Either(ArrayOf(String), nil)
        end
      end
    end

    module MetaData
      class V1
        extend Messages::Payload

        schema do
          source Either("seeker", "non-seeker")
          id Either(Uuid, nil), default: nil
        end
      end

      class V2
        extend Messages::Payload

        schema do
          source Either("seeker", "user", "unauthenticated")
          id Either(String, nil), default: nil
          utm_source Either(String, nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: MetaData::V1,
      aggregate: Aggregates::User,
      message_type: Messages::Types::JobSearch::JOB_SEARCH,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: MetaData::V2,
      aggregate: Aggregates::Search,
      message_type: Messages::Types::JobSearch::JOB_SEARCH,
      version: 2
    )
  end
end
