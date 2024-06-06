module Events
  module UserBasicInfoAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
          first_name String
          last_name String
          phone_number Either(String, nil)
          date_of_birth Either(Date, nil), coerce: Messages::DateCoercer
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::USER_BASIC_INFO_ADDED,
      version: 1
    )
  end
end
