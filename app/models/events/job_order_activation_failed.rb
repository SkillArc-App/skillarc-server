module Events
  module JobOrderActivationFailed
    module Data
      class V1
        extend Core::Payload

        schema do
          reason String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::JOB_ORDER_ACTIVATION_FAILED,
      version: 1
    )
  end
end
