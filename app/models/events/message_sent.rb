module Events
  module MessageSent
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::Message,
      message_type: MessageTypes::Contact::MESSAGE_SENT,
      version: 1
    )
  end
end
