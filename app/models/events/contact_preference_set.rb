module Events
  module ContactPreferenceSet
    module Data
      class V1
        extend Messages::Payload

        schema do
          preference Either(*Contact::ContactPreference::ALL)
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::User,
      message_type: Messages::Types::Contact::CONTACT_PREFERENCE_SET,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Contact::CONTACT_PREFERENCE_SET,
      version: 2
    )
  end
end
