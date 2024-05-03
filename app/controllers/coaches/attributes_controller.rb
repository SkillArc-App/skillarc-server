module Coaches
  class AttributesController < ApplicationController
    include Secured
    include CoachAuth
    include MessageEmitter

    before_action :authorize
    before_action :coach_authorize
    before_action :set_coach

    def create
      with_message_service do
        CoachesReactor.new(message_service:).add_attribute(
          seeker_attribute_id: SecureRandom.uuid,
          seeker_id: params[:seeker_id],
          attribute_id: params[:attribute_id],
          attribute_name: params[:name],
          attribute_value: params[:value],
          trace_id: request.request_id
        )
      end

      head :created
    end

    def update
      with_message_service do
        CoachesReactor.new(message_service:).add_attribute(
          seeker_attribute_id: params[:id],
          seeker_id: params[:seeker_id],
          attribute_id: params[:attribute_id],
          attribute_name: params[:name],
          attribute_value: params[:value],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    def destroy
      with_message_service do
        CoachesReactor.new(message_service:).remove_attribute(
          seeker_attribute_id: params[:id],
          seeker_id: params[:seeker_id],
          trace_id: request.request_id
        )
      end

      head :accepted
    end

    private

    attr_reader :coach

    def set_coach
      @coach = Coach.find_by(user_id: current_user.id)
    end
  end
end
