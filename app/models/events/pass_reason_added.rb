module Events
  module PassReasonAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          description String
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::PassReason,
      message_type: Messages::Types::Jobs::PASS_REASON_ADDED,
      version: 1
    )
  end
end
