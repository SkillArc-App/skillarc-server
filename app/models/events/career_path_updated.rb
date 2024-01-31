module Events
  module CareerPathUpdated
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          id String
          job_id Either(String, nil)
          title Either(String, nil)
          lower_limit Either(String, nil)
          upper_limit Either(String, nil)
          order Either(Integer, nil)
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CAREER_PATH_UPDATED,
      version: 1
    )
  end
end
