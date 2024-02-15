module Events
  module UserUpdated
    module Data
      class V1
        extend Concerns::Payload
        include Concerns::Splat

        schema do
          first_name Either(String, nil)
          last_name Either(String, nil)
          phone_number Either(String, nil)
          date_of_birth Either(Date, Common::UNDEFINED, nil), default: Common::UNDEFINED, coerce: Common::DateCoercer
          email Either(String, Common::UNDEFINED, nil), default: Common::UNDEFINED
          zip_code Either(/^\d{5}(?:[-\s]\d{4})?$/, Common::UNDEFINED, nil), default: Common::UNDEFINED
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::USER_UPDATED,
      version: 1
    )
  end
end
