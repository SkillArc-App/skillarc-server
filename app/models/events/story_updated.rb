module Events
  module StoryUpdated
    module Data
      class V1
        extend Messages::Payload

        schema do
          id Uuid
          prompt String
          response String
        end
      end
    end

    V1 = Messages::Schema.deprecated(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Person::STORY_UPDATED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Person,
      message_type: Messages::Types::Person::STORY_UPDATED,
      version: 2
    )
  end
end
