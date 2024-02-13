class JobsController < ApplicationController
  include Secured
  include Admin

  before_action :authorize, only: %i[apply create update index]
  before_action :admin_authorize, only: %i[index create update]

  def apply
    job = Job.find(params[:job_id])

    applicant = Applicant.find_or_initialize_by(seeker_id: current_user.seeker.id, job_id: job.id) do |a|
      a.id = SecureRandom.uuid
      a.save!
      ApplicantService.new(a).update_status(status: ApplicantStatus::StatusTypes::NEW)
    end

    render json: { applicant: }
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

  def create
    job = Jobs::JobService.new.create(
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
        industry: []
      ).to_h.symbolize_keys
    )

    render json: serialize_job(job)
  end

  def update
    job = Job.find(params[:id])

    render json: serialize_job(
      Jobs::JobService.new.update(
        job,
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
          :work_day,
          :requirements_description,
          industry: []
        ).to_h.symbolize_keys
      )
    )
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
