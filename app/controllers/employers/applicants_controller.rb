class Employers::ApplicantsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def update
    applicant = Applicant.find(params[:id])

    ApplicantService.new(applicant).update_status(params[:status])

    render json: applicant
  end
end
