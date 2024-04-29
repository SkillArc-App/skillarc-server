module Events
  module ZipAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          zip_code Either(/^\d{5}(?:[-\s]\d{4})?$/, nil), coerce: Messages::ZipCodeCoercer
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::ZIP_ADDED,
      version: 1
    )
  end
end
