module Events
  module RoleAdded
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Event::EventTypes::ROLE_ADDED,
      version: 1
    )
  end
end
