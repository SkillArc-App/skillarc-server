class JobsController < ApplicationController
  include Secured

  before_action :authorize, only: %i[apply elevator_pitch]

  def apply
    job = Job.find(params[:job_id])

    applicant = Applicant.find_or_initialize_by(seeker_id: current_user.seeker.id, job_id: job.id) do |a|
      a.id = SecureRandom.uuid
      a.save!
      ApplicantService.new(a).update_status(status: ApplicantStatus::StatusTypes::NEW, user_id: current_user.id)
    end

    render json: { applicant: }
  end

  def elevator_pitch
    job = Job.find(params[:job_id])

    Seekers::JobService.new(job:, seeker: current_user.seeker).add_elevator_pitch(params[:elevator_pitch])

    head :accepted
  end

  def show
    job = Job.includes(
      :applicants,
      :career_paths,
      :employer,
      :job_photos,
      :testimonials,
      job_tags: :tag,
      desired_skills: :master_skill,
      learned_skills: :master_skill,
      desired_certifications: :master_certification
    ).find(params[:id])

    render json: serialize_job(job)
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
