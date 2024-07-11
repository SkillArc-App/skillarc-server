module Events
  module JobAttributeCreated
    module Data
      class V1
        extend Core::Payload

        schema do
          id Uuid
          attribute_id Uuid
          attribute_name String
          acceptible_set ArrayOf(String)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Streams::Job,
      message_type: MessageTypes::Jobs::JOB_ATTRIBUTE_CREATED,
      version: 1
    )
  end
end
