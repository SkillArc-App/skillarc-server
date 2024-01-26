module Events
  module RoleAdded
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::ROLE_ADDED,
      version: 1
    )
  end
end
