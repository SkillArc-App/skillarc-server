module Attributes
  module Events
    module Deleted
      V1 = Core::Schema.inactive(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_DELETED,
        version: 1
      )
      V2 = Core::Schema.active(
        type: Core::EVENT,
        data: Core::Nothing,
        metadata: Core::RequestorMetadata::V1,
        stream: Streams::Attribute,
        message_type: MessageTypes::ATTRIBUTE_DELETED,
        version: 2
      )
    end
  end
end
