module Events
  module ChatCreated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::CHAT_CREATED,
      version: 1
    )
  end
end
