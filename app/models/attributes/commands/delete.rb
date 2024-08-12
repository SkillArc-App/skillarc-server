module Attributes
  module Commands
    module Delete
      V1 = Core::Schema.active(
        type: Core::COMMAND,
        data: Core::Nothing,
        metadata: Core::Nothing,
        stream: Streams::Attribute,
        message_type: MessageTypes::DELETE_ATTRIBUTE,
        version: 1
      )
    end
  end
end
