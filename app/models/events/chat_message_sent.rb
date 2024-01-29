module Events
  module ChatMessageSent
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CHAT_MESSAGE_SENT,
      version: 1
    )
  end
end
