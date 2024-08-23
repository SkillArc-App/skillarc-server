module Coaches
  class FeedsController < CoachesController
    def index
      render json: FeedEvent.all.map { |feed_event| feed_event.as_json(only: %i[id context_id description occurred_at seeker_email]) }
    end
  end
end
