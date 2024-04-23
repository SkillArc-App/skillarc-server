module Commands
  module SetContactPreference
    module Data
      class V1
        extend Messages::Payload

        schema do
          preference Either(*Contact::ContactPreference::ALL)
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Contact::SET_CONTACT_PREFERENCE,
      version: 1
    )
  end
end
