module Events
  module CareerPathCreated
    module Data
      class V1
        extend Payload

        schema do
          id String
          job_id String
          title String
          lower_limit String
          upper_limit String
          order Integer
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
