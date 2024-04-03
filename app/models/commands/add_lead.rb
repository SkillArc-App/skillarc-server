module Commands
  module AddLead
    module Data
      class V1
        extend Messages::Payload

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

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::ADD_LEAD,
      version: 1
    )
  end
end
