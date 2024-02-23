class Employers::JobsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def index
    employers = if current_user.employer_admin?
                  Employers::Employer.all
                else
                  [Employers::Recruiter.find_by(email: current_user.email).employer]
                end

    jobs = Employers::JobService.new(employers:).all
    applicants = Employers::ApplicantService.new(employers:).all

    render json: { jobs:, applicants: }
  end
end
