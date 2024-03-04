module Events
  module RoleAdded
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::ROLE_ADDED,
      version: 1
    )
  end
end
