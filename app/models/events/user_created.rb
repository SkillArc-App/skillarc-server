module Events
  module UserCreated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::USER_CREATED,
      version: 1
    )
  end
end
