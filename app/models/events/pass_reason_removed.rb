module Events
  module PassReasonRemoved
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::PassReason,
      message_type: MessageTypes::Jobs::PASS_REASON_REMOVED,
      version: 1
    )
  end
end
