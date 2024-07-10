module Events
  module MessageEnqueued
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::Message,
      message_type: MessageTypes::Contact::MESSAGE_ENQUEUED,
      version: 1
    )
  end
end
