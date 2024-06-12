module Events
  module KlaviyoEventPushed
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Klaviyo,
      message_type: Messages::Types::Contact::KLAVIYO_EVENT_PUSHED,
      version: 1
    )
  end
end
