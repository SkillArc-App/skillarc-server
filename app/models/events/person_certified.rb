module Events
  module PersonCertified
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_first_name Either(String, nil)
          coach_last_name Either(String, nil)
          coach_email String
          coach_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PERSON_CERTIFIED,
      version: 1
    )
  end
end
