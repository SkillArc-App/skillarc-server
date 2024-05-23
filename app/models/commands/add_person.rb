module Commands
  module AddPerson
    module Data
      class V1
        extend Messages::Payload

        schema do
          first_name String
          last_name String
          email Either(String, nil)
          phone_number Either(String, nil)
        end

        def initialize(**kwarg)
          raise ArgumentError unless kwarg[:email].present? || kwarg[:phone_number].present?

          super(**kwarg)
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
