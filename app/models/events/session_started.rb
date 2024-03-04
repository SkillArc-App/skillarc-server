module Events
  module SessionStarted
    V1 = Messages::Schema.build(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::SESSION_STARTED,
      version: 1
    )
  end
end
