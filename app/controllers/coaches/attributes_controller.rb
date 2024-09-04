module Coaches
  class AttributesController < CoachesController
    def create
      with_message_service do
        CoachesEventEmitter.new(message_service:).add_attribute(
          person_attribute_id: SecureRandom.uuid,
          person_id: params[:seeker_id],
          attribute_id: params[:attribute_id],
          attribute_value_ids: params[:attribute_value_ids],
          trace_id: request.request_id
        )
      end

      head :created
    end

    def update
      with_message_service do
        CoachesEventEmitter.new(message_service:).add_attribute(
          person_attribute_id: params[:id],
          person_id: params[:seeker_id],
          attribute_id: params[:attribute_id],
          attribute_value_ids: params[:attribute_value_ids],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def destroy
      with_message_service do
        CoachesEventEmitter.new(message_service:).remove_attribute(
          person_attribute_id: params[:id],
          person_id: params[:seeker_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end
  end
end
