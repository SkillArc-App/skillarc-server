module Events
  module PassReasonRemoved
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::PassReason,
      message_type: Messages::Types::Jobs::PASS_REASON_REMOVED,
      version: 1
    )
  end
end
