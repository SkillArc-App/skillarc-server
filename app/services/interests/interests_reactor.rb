module Interests
  class InterestsReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::SetInterests::V1 do |message|
      message_service.create_once_for_trace!(
        stream: message.stream,
        trace_id: message.trace_id,
        schema: Events::InterestsSet::V1,
        data: {
          interests: message.data.interests
        }
      )
    end
  end
end
