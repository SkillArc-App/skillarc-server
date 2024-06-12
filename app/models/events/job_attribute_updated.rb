module Events
  module JobAttributeUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          acceptible_set ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::Jobs::JOB_ATTRIBUTE_UPDATED,
      version: 1
    )
  end
end
