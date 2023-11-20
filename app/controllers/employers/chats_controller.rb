class Employers::ChatsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize
  before_action :set_r

  def index
    render json: EmployerChats.new(r).get
  end

  def send_message
    EmployerChats.new(r).send_message(
      applicant_id: params[:applicant_id],
      message: params[:message]
    )

    render json: { message: "Message sent" }
  end

  def create
    EmployerChats.new(r).create(applicant_id: params[:applicant_id])

    render json: { message: "Chat created" }
  end

  private

  attr_reader :r

  def set_r
    @r = if current_user.employer_admin?
      EmployerChats::Recruiter.new(current_user, Employer.all.pluck(:id))
    else
      EmployerChats::Recruiter.new(recruiter.user, recruiter.employer_id)
    end
  end
end