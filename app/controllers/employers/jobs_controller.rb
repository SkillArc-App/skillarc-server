class Employers::JobsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def index
    # jobs = current_user.employer_admin? ? Job.all.with_employer_info : recruiter.employer.jobs.with_employer_info
    employers = current_user.employer_admin? ? Employers::Employer.all : [recruiter.employer]

    jobs = Employers::JobService.new(employers:).all
    # Because the reason list is small we just load all of them
    # and do in memory lookups
    # reasons = Reason.all

    applicants = Employers::ApplicantService.new(employers:).all

    # applicants = jobs.map do |job|
    #   job.applicants.map do |a|
    #     applicant_status = a.applicant_statuses.max_by(&:created_at)

    #     status_reasons = applicant_status&.applicant_status_reasons&.map do |asr|
    #       reasons.detect { |r| r.id == asr.reason_id }&.description
    #     end

    #     {
    #       id: a.id,
    #       job_id: job.id,
    #       chat_enabled: job.employer.chat_enabled,
    #       created_at: a.created_at,
    #       job_name: job.employment_title,
    #       first_name: a.seeker.user.first_name,
    #       last_name: a.seeker.user.last_name,
    #       email: a.seeker.user.email,
    #       phone_number: a.seeker.user.phone_number,
    #       profile_link: "/profiles/#{a.seeker.id}",
    #       programs: [],
    #       status_reasons:,
    #       status: applicant_status&.status
    #     }
    #   end
    # end.flatten

    render json: { jobs:, applicants: }
  end
end
