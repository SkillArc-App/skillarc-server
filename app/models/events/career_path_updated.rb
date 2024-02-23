module Events
  module CareerPathUpdated
    module Data
      class V1
        extend Messages::Payload

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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Messages::Types::Jobs::CAREER_PATH_UPDATED,
      version: 1
    )
  end
end
