module Events
  module SessionStarted
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::SESSION_STARTED,
      version: 1
    )
  end
end
