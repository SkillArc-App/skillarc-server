class Employers::ApplicantsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def update
    applicant = Applicant.find(params[:id])

    applicant.applicant_statuses << ApplicantStatus.new(
      id: SecureRandom.uuid,
      status: params[:status]
    )
    applicant.save!

    render json: applicant
  end
end
