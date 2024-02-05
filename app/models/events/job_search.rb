module Events
  module JobSearch
    module Data
      class V1
        extend Payload

        schema do
          search_terms Either(String, nil)
          industries Either(ArrayOf(String), nil)
          tags Either(ArrayOf(String), nil)
        end
      end
    end

    module MetaData
      class V1
        extend Payload

        schema do
          source Either("seeker", "non-seeker")
          id Either(Uuid, nil), default: nil
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: MetaData::V1,
      event_type: Event::EventTypes::JOB_SEARCH,
      version: 1
    )
  end
end
