module Events
  module UserCreated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::USER_CREATED,
      version: 1
    )
  end
end
