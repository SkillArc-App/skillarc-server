module Commands
  module AddJobOrder
    module Data
      class V1
        extend Messages::Payload

        schema do
          job_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::ADD_JOB_ORDER,
      version: 1
    )
  end
end
