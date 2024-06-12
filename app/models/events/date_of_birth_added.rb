module Events
  module DateOfBirthAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          date_of_birth Date, coerce: Messages::DateCoercer
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::DATE_OF_BIRTH_ADDED,
      version: 1
    )
  end
end
