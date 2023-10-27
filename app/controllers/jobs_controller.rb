class JobsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize, only: [:apply, :create, :update, :index]
  before_action :admin_authorize, only: [:index, :create, :update]

  def apply
    job = Job.find(params[:job_id])

    applicant = Applicant.find_or_initialize_by(profile_id: current_user.profile.id, job_id: job.id) do |a|
      a.id = SecureRandom.uuid
      a.save!
      ApplicantService.new(a).update_status(ApplicantStatus::StatusTypes::NEW)
    end

    render json: { applicant: }
  end

  def create
    begin
      job = Job.create!(
        **params.require(:job).permit(
          :employment_title,
          :employer_id,
          :benefits_description,
          :responsibilities_description,
          :employment_title,
          :location,
          :employment_type,
          :hide_job,
          :schedule,
          :work_days,
          :requirements_description,
          :industry
        ),
        id: SecureRandom.uuid
      )
      render json: serialize_job(job)
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def update
    begin
      job = Job.find(params[:id])

      job.update!(
        params.require(:job).permit(
          :employment_title,
          :employer_id,
          :benefits_description,
          :responsibilities_description,
          :employment_title,
          :location,
          :employment_type,
          :hide_job,
          :schedule,
          :work_day,
          :requirements_description,
          industry: []
        )
      )

      render json: serialize_job(job)
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def index
    jobs = Job.includes(
      :applicants,
      :career_paths,
      :employer,
      :job_photos,
      :testimonials,
      job_tags: :tag,
      desired_skills: :master_skill,
      learned_skills: :master_skill,
      desired_certifications: :master_certification
    ).all

    render json: jobs.map { |j| serialize_job(j) }
  end

  def show
    render json: serialize_job(Job.find(params[:id]))
  end

  private

  def serialize_job(j)
    {
      **j.as_json,
      industry: j.industry || [],
      employer: j.employer.as_json,
      learnedSkills: j.learned_skills.map do |ls|
        {
          **ls.as_json,
          masterSkill: ls.master_skill.as_json
        }
      end.as_json,
      desiredSkills: j.desired_skills.map do |ds|
        {
          **ds.as_json,
          masterSkill: ds.master_skill.as_json
        }
      end.as_json,
      desiredCertifications: j.desired_certifications.map do |dc|
        {
          **dc.as_json,
          masterCertification: dc.master_certification.as_json
        }
      end,
      careerPaths: j.career_paths.as_json,
      jobPhotos: j.job_photos.as_json,
      jobTag: j.job_tags.map do |jt|
        {
          **jt.as_json,
          tag: jt.tag.as_json
        }
      end.as_json,
      numberOfApplicants: j.applicants.length,
      testimonials: j.testimonials.as_json
    }
  end
end
