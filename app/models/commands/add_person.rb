module Commands
  module AddPerson
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id Either(String, nil)
          first_name String
          last_name String
          email Either(String, nil)
          phone_number Either(String, nil)
          date_of_birth Either(Date, nil), coerce: Messages::DateCoercer
        end

        def initialize(**kwarg)
          super(**kwarg)
          raise ArgumentError unless kwarg[:email].present? || kwarg[:phone_number].present?
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::ADD_PERSON,
      version: 1
    )
  end
end
