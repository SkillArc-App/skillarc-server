module Events
  module CareerPathUpdated
    module Data
      class V1
        extend Payload

        schema do
          id Uuid
          job_id Either(Uuid, nil), default: nil
          title Either(String, nil), default: nil
          lower_limit Either(String, nil), default: nil
          upper_limit Either(String, nil), default: nil
          order Either(Integer, nil), default: nil
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
