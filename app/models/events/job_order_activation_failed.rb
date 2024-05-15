module Events
  module JobOrderActivationFailed
    module Data
      class V1
        extend Messages::Payload

        schema do
          reason String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_ACTIVATION_FAILED,
      version: 1
    )
  end
end
