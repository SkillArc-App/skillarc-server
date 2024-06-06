module Events
  module SeekerCertified
    module Data
      class V1
        extend Messages::Payload

        schema do
          coach_first_name Either(String, nil), default: nil
          coach_last_name Either(String, nil), default: nil
          coach_email String
          coach_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Coaches::SEEKER_CERTIFIED,
      version: 1
    )
  end
end
