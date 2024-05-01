module Events
  module BasicInfoAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
          first_name String
          last_name String
          phone_number String
          date_of_birth Either(Date, nil), coerce: Messages::DateCoercer
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::BASIC_INFO_ADDED,
      version: 1
    )
  end
end
