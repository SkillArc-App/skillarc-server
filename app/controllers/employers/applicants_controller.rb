class Employers::ApplicantsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def update
    applicant = Applicant.find(params[:id])

    status = applicant_update_params[:status]
    reasons = applicant_update_params[:reasons]

    reasons = reasons.map { |r| { id: r, response: nil } } if reasons&.all? { |r| r.is_a?(String) }

    ApplicantService.new(applicant).update_status(status:, reasons: reasons || [])

    render json: applicant
  end

  def applicant_update_params
    params.permit(:status, reasons: [])
  end
end
