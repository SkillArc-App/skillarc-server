module Events
  module CareerPathCreated
    module Data
      class V1
        include(ValueSemantics.for_attributes do
          id String
          job_id String
          title String
          lower_limit String
          upper_limit String
          order Integer
        end)

        def self.from_hash(hash)
          new(**hash)
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CAREER_PATH_CREATED,
      version: 1
    )
  end
end
