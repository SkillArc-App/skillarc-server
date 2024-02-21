module Events
  module LeadAdded
    module Data
      class V1
        extend Concerns::Payload

        schema do
          email Either(String, nil), default: nil
          lead_id Uuid
          phone_number String
          first_name String
          last_name String
          lead_captured_by String
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::LEAD_ADDED,
      version: 1
    )
  end
end
