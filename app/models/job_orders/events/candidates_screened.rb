module JobOrders
  module Events
    module CandidatesScreened
      V1 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        aggregate: Aggregates::JobOrder,
        message_type: MessageTypes::JOB_ORDER_CANDIDATES_SCREENED,
        version: 1
      )
    end
  end
end
