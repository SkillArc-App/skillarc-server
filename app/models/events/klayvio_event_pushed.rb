module Events
  module KlayvioEventPushed
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Klayvio,
      message_type: Messages::Types::Contact::KLAYVIO_EVENT_PUSHED,
      version: 1
    )
  end
end
