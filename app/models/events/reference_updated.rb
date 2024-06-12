module Events
  module ReferenceUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          reference_text String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Reference,
      message_type: Messages::Types::TrainingProviders::REFERENCE_UPDATED,
      version: 1
    )
  end
end
