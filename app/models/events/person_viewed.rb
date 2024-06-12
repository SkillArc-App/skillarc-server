module Events
  module PersonViewed
    module Data
      class V1
        extend Messages::Payload

        schema do
          person_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::User,
      message_type: Messages::Types::Person::PERSON_VIEWED,
      version: 1
    )
  end
end
