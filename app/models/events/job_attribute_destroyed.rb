module Events
  module JobAttributeDestroyed
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
      stream: Streams::Job,
      message_type: Messages::Types::Jobs::JOB_ATTRIBUTE_DESTROYED,
      version: 1
    )
  end
end
