module Events
  module AttributeDeleted
    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Streams::Attribute,
      message_type: MessageTypes::Attributes::ATTRIBUTE_DELETED,
      version: 1
    )
  end
end
