class Seekers::ChatsController < ApplicationController
  include Secured

  before_action :authorize

  def index
    render json: SeekerChats.new(current_user).get
  end

  def mark_read
    SeekerChats.new(current_user).mark_read(
      applicant_id: params[:applicant_id]
    )

    render json: { success: true }
  end

  def send_message
    SeekerChats.new(current_user).send_message(
      applicant_id: params[:applicant_id],
      message: params[:message]
    )

    render json: { message: "Message sent" }
  end
end
