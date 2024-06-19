module Events
  module KlaviyoEventPushed
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::Klaviyo,
      message_type: MessageTypes::Contact::KLAVIYO_EVENT_PUSHED,
      version: 1
    )
  end
end
