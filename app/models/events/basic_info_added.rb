module Events
  module BasicInfoAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name String
          last_name String
          phone_number Either(String, nil)
          email Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::BASIC_INFO_ADDED,
      version: 1
    )
  end
end
