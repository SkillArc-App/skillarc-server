module Events
  module PersonAttributeRemoved
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PERSON_ATTRIBUTE_REMOVED,
      version: 1
    )
  end
end
