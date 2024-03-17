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

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Seeker,
      message_type: Messages::Types::Seekers::STORY_UPDATED,
      version: 1
    )
  end
end
