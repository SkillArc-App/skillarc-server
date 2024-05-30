module Events
  module CareerPathUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          order Either(0.., nil), default: nil
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Job,
      message_type: Messages::Types::Jobs::CAREER_PATH_UPDATED,
      version: 1
    )
  end
end
