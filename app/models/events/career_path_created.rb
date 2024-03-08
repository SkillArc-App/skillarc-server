module Events
  module CareerPathCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          job_id Uuid
          title Either(String, nil), default: nil
          lower_limit Either(String, nil), default: nil
          upper_limit Either(String, nil), default: nil
          order 0..
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::CAREER_PATH_CREATED,
      version: 1
    )
  end
end
