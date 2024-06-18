module Events
  module PersonAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name String
          last_name String
          email Either(String, nil)
          phone_number Either(String, nil)
          date_of_birth Either(Date, nil), coerce: Messages::DateCoercer
        end

        def initialize(**kwarg)
          super
          raise ArgumentError unless kwarg[:email].present? || kwarg[:phone_number].present?
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::PERSON_ADDED,
      version: 1
    )
  end
end
