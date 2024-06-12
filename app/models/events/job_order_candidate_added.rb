module Events
  module JobOrderCandidateAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          seeker_id Uuid
        end
      end

      class V2
        extend Messages::Payload

        schema do
          person_id Uuid
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_CANDIDATE_ADDED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      stream: Streams::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_CANDIDATE_ADDED,
      version: 2
    )
  end
end
