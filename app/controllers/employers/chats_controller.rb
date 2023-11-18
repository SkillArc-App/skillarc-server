class Employers::ChatsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def index
    render json: EmployerChats.new(recruiter).get
  end

  def send_message
    EmployerChats.new(recruiter).send_message(
      applicant_id: params[:applicant_id],
      message: params[:message]
    )

    render json: { message: "Message sent" }
  end

  def create
    EmployerChats.new(recruiter).create(applicant_id: params[:applicant_id])

    render json: { message: "Chat created" }
  end
end