module Events
  module MessageEnqueued
    V1 = Messages::Schema.active(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Message,
      message_type: Messages::Types::Contact::MESSAGE_ENQUEUED,
      version: 1
    )
  end
end
