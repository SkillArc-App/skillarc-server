module Events
  module UserUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name Either(String, nil)
          last_name Either(String, nil)
          phone_number Either(String, nil)
          date_of_birth Either(Date, nil), default: nil, coerce: Messages::DateCoercer
          email Either(String, nil), default: nil
          zip_code Either(/^\d{5}(?:[-\s]\d{4})?$/, nil), default: nil, coerce: Messages::ZipCodeCoercer
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::User::USER_UPDATED,
      version: 1
    )
  end
end
