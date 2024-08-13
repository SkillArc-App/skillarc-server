module Interests
  class InterestsAggregator < MessageConsumer
    def reset_for_replay
      Interest.delete_all
    end

    on_message Events::InterestsSet::V1 do |message|
      Interest.delete_all
      Interest.create!(interests: message.data.interests)
    end
  end
end
