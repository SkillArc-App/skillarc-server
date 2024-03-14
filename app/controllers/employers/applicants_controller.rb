class Employers::ApplicantsController < ApplicationController
  include Secured
  include EmployerAuth
  include EventEmitter

  before_action :authorize
  before_action :employer_authorize

  def update
    applicant = Applicant.find(params[:id])

    status = applicant_update_params[:status]
    reasons = applicant_update_params[:reasons]&.map(&:to_h)

    with_event_service do
      ApplicantService.new(applicant).update_status(status:, user_id: current_user.id, reasons: reasons || [])
    end

    render json: applicant
  end

  def applicant_update_params
    params.permit(:status, reasons: %i[id response])
  end
end
