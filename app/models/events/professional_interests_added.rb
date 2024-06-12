module Events
  module ProfessionalInterestsAdded
    module Data
      class V1
        extend Messages::Payload

        schema do
          interests ArrayOf(String)
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Seeker,
      message_type: Messages::Types::Person::PROFESSIONAL_INTERESTS,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Person,
      message_type: Messages::Types::Person::PROFESSIONAL_INTERESTS,
      version: 2
    )
  end
end
