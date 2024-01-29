module Events
  module RoleAdded
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::ROLE_ADDED,
      version: 1
    )
  end
end
