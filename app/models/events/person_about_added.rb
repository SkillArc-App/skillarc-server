module Events
  module PersonAboutAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          about Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::PERSON_ABOUT_ADDED,
      version: 1
    )
  end
end
