class Employers::JobsController < ApplicationController
  include Secured
  include EmployerAuth

  before_action :authorize
  before_action :employer_authorize

  def index
    jobs = current_user.employer_admin? ? Job.all.with_employer_info : recruiter.employer.jobs.with_employer_info

    ret_jobs = jobs.map do |job|
      {
        id: job.id,
        employerId: job.employer_id,
        employerName: job.employer.name,
        name: job.employment_title,
        description: "descriptions don't exist yet"
      }
    end

    # Because the reason list is small we just load all of them
    # and do in memory lookups
    reasons = Reason.all

    applicants = jobs.map do |job|
      job.applicants.map do |a|
        applicant_status = a.applicant_statuses.max_by(&:created_at)

        status_reasons = applicant_status&.applicant_status_reasons&.map do |asr|
          reasons.detect { |r| r.id == asr.reason_id }&.description
        end

        {
          id: a.id,
          jobId: job.id,
          chatEnabled: job.employer.chat_enabled,
          createdAt: a.created_at,
          jobName: job.employment_title,
          firstName: a.seeker.user.first_name,
          lastName: a.seeker.user.last_name,
          email: a.seeker.user.email,
          phoneNumber: a.seeker.user.phone_number,
          profileLink: "/profiles/#{a.seeker.id}",
          programs: [],
          status_reasons:,
          status: applicant_status&.status
        }
      end
    end.flatten

    render json: { jobs: ret_jobs, applicants: }
  end
end
