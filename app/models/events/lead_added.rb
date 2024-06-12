module Events
  module LeadAdded
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

    V1 = Messages::Schema.destroy!(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coach,
      message_type: Messages::Types::Coaches::LEAD_ADDED,
      version: 1
    )
    V2 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Coaches::SeekerContext,
      message_type: Messages::Types::Coaches::LEAD_ADDED,
      version: 2
    )
  end
end
