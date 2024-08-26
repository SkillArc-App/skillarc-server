module Coaches
  class FeedsController < CoachesController
    def index
      feed_events = FeedEvent.order(occurred_at: :desc).take(300).map do |feed_event|
        {
          id: feed_event.id.to_s,
          context_id: feed_event.person_id,
          description: feed_event.description,
          occurred_at: feed_event.occurred_at,
          seeker_email: feed_event.person_email,
          seeker_phone_number: feed_event.person_phone
        }
      end

      render json: feed_events
    end
  end
end
