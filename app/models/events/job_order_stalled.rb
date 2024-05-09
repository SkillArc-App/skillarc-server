module Events
  module JobOrderStalled
    module Data
      class V1
        extend Messages::Payload

        schema do
          status Either(*JobOrders::StalledStatus::ALL)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_STALLED,
      version: 1
    )
  end
end
