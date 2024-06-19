module Events
  module JobOrderStalled
    module Data
      class V1
        extend Core::Payload

        schema do
          status Either(*JobOrders::StalledStatus::ALL)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: MessageTypes::JobOrders::JOB_ORDER_STALLED,
      version: 1
    )
  end
end
