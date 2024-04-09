module Seekers
  class StoriesService
    include MessageEmitter

    def initialize(seeker)
      @seeker = seeker
    end

    def create(prompt:, response:)
      story = seeker.stories.create!(id: SecureRandom.uuid, prompt:, response:)

      message_service.create!(
        schema: Events::StoryCreated::V1,
        seeker_id: seeker.id,
        data: {
          id: story.id,
          prompt:,
          response:
    }
      )

      story
    end

    def update(story:, prompt:, response:)
      story.update!(prompt:, response:)

      message_service.create!(
        schema: Events::StoryUpdated::V1,
        seeker_id: seeker.id,
        data: {
          id: story.id,
          prompt:,
          response:
    }
      )

      story
    end

    def destroy(story:)
      story.destroy!

      message_service.create!(
        schema: Events::StoryDestroyed::V1,
        seeker_id: seeker.id,
        data: {
          id: story.id
    }
      )
    end

    private

    attr_reader :seeker
  end
end
