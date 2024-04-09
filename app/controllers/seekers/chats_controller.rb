module Seekers
  class ChatsController < ApplicationController
    include Secured
    include MessageEmitter

    before_action :authorize

    def index
      render json: SeekerChats.new(current_user).get
    end

    def mark_read
      with_message_service do
        SeekerChats.new(current_user).mark_read(
          applicant_id: params[:applicant_id]
        )
      end

      render json: { success: true }
    end

    def send_message
      with_message_service do
        SeekerChats.new(current_user).send_message(
          applicant_id: params[:applicant_id],
          message: params[:message]
        )
      end

      render json: { message: "Message sent" }
    end
  end
end
