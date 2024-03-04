module Events
  module BarrierAdded
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Coaches::BARRIER_ADDED,
      version: 1
    )
  end
end
