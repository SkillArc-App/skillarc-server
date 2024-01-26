module Events
  module UserUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::USER_UPDATED,
      version: 1
    )
  end
end
