module Events
  module UserUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name Either(String, nil)
          last_name Either(String, nil)
          phone_number Either(String, nil)
          date_of_birth Either(Date, Messages::UNDEFINED, nil), default: Messages::UNDEFINED, coerce: Messages::DateCoercer
          email Either(String, Messages::UNDEFINED, nil), default: Messages::UNDEFINED
          zip_code Either(/^\d{5}(?:[-\s]\d{4})?$/, Messages::UNDEFINED, nil), default: Messages::UNDEFINED, coerce: Messages::ZipCodeCoercer
        end
      end
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      message_type: Messages::Types::USER_UPDATED,
      version: 1
    )
  end
end
