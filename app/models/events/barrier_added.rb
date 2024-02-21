module Events
  module BarrierAdded
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      event_type: Messages::Types::BARRIER_ADDED,
      version: 1
    )
  end
end
