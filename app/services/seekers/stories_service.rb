module Seekers
  class StoriesService
    include EventEmitter

    def initialize(seeker)
      @seeker = seeker
    end

    def create(prompt:, response:)
      story = seeker.stories.create!(id: SecureRandom.uuid, prompt:, response:)

      event_service.create!(
        event_schema: Events::StoryCreated::V1,
        seeker_id: seeker.id,
        data: Events::StoryCreated::Data::V1.new(
          id: story.id,
          prompt:,
          response:
        )
      )

      story
    end

    def update(story:, prompt:, response:)
      story.update!(prompt:, response:)

      event_service.create!(
        event_schema: Events::StoryUpdated::V1,
        seeker_id: seeker.id,
        data: Events::StoryUpdated::Data::V1.new(
          id: story.id,
          prompt:,
          response:
        )
      )

      story
    end

    def destroy(story:)
      story.destroy!

      event_service.create!(
        event_schema: Events::StoryDestroyed::V1,
        seeker_id: seeker.id,
        data: Events::StoryDestroyed::Data::V1.new(
          id: story.id
        )
      )
    end

    private

    attr_reader :seeker
  end
end
