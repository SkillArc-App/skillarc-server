module Events
  module AttributeDeleted
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      stream: Streams::Attribute,
      message_type: Messages::Types::Attributes::ATTRIBUTE_DELETED,
      version: 1
    )
  end
end
