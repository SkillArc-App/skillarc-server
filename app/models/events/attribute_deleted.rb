module Events
  module AttributeDeleted
    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Attribute,
      message_type: Messages::Types::Attributes::ATTRIBUTE_DELETED,
      version: 1
    )
  end
end
