module Events
  module JobSearch
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          search_terms Either(String, nil)
          industries Either(ArrayOf(String), nil)
          tags Either(ArrayOf(String), nil)
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    module MetaData
      class V1
        include(ValueSemantics.for_attributes do
          source Either("seeker", "non-seeker")
          id Either(Uuid, nil), default: nil
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: MetaData::V1,
      event_type: Event::EventTypes::JOB_SAVED,
      version: 1
    )
  end
end
