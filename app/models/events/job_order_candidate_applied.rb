module Events
  module JobOrderCandidateApplied
    module Data
      class V1
        extend Messages::Payload

        schema do
          seeker_id Uuid
          applied_at ActiveSupport::TimeWithZone, coerce: Messages::TimeZoneCoercer
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::JobOrder,
      message_type: Messages::Types::JobOrders::JOB_ORDER_CANDIDATE_APPLIED,
      version: 1
    )
  end
end
