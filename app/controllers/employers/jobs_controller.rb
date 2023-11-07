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

    applicants = jobs.map do |job|
      job.applicants.map do |a|
        {
          id: a.id,
          jobId: job.id,
          jobName: job.employment_title,
          firstName: a.profile.user.first_name,
          lastName: a.profile.user.last_name,
          email: a.profile.user.email,
          phoneNumber: a.profile.user.phone_number,
          profileLink: "/profiles/#{a.profile.id}",
          programs: [],
          status: a.applicant_statuses.sort_by(&:created_at).last&.status
        }
      end
    end.flatten

    render json: { jobs: ret_jobs, applicants: }
  end
end
