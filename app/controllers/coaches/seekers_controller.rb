module Coaches
  class SeekersController < CoachesController
    before_action :set_coach

    def certify
      with_message_service do
        CoachesEventEmitter.new(message_service:).certify(person_id: params[:seeker_id], coach:, trace_id: request.request_id)
      end

      head :accepted
    end
  end
end
