module Employers
  class ChatsController < ApplicationController
    include Secured
    include EmployerAuth
    include MessageEmitter

    before_action :authorize
    before_action :employer_authorize
    before_action :set_r

    def index
      render json: EmployerChats.new(r).get
    end

    def mark_read
      with_message_service do
        EmployerChats.new(r).mark_read(
          applicant_id: params[:applicant_id]
        )
      end

      render json: { success: true }
    end

    def send_message
      with_message_service do
        EmployerChats.new(r).send_message(
          applicant_id: params[:applicant_id],
          message: params[:message]
        )
      end

      render json: { message: "Message sent" }
    end

    def create
      with_message_service do
        EmployerChats.new(r).create(applicant_id: params[:applicant_id])
      end

      render json: { message: "Chat created" }
    end

    private

    attr_reader :r

    def set_r
      @r = if current_user.employer_admin?
             EmployerChats::Recruiter.new(current_user, ::Employer.pluck(:id))
           else
             EmployerChats::Recruiter.new(recruiter.user, recruiter.employer_id)
           end
    end
  end
end
