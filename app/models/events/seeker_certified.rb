module Events
  module SeekerCertified
    module Data
      class V1
        extend Concerns::Payload

        schema do
          coach_first_name Either(String, nil), default: nil
          coach_last_name Either(String, nil), default: nil
          coach_email String
          coach_id Uuid
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::SEEKER_CERTIFIED,
      version: 1
    )
  end
end
