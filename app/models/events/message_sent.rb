module Events
  module MessageSent
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::MESSAGE_SENT,
      version: 1
    )
  end
end
