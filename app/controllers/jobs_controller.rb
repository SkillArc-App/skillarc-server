class JobsController < ApplicationController
  include Secured
  include CommandEmitter
  include EventEmitter

  before_action :authorize, only: %i[apply elevator_pitch]

  def apply
    job = Job.find(params[:job_id])

    message_service = MessageService.new

    command_service = CommandService.new(message_service:)
    event_service = EventService.new(message_service:)

    with_command_service(command_service) do
      with_event_service(event_service) do
        seeker = current_user.seeker

        Seekers::ApplicantService.new(seeker).apply(job)
      end
    end

    head :ok
  end

  def elevator_pitch
    job = Job.find(params[:job_id])

    with_event_service do
      Seekers::JobService.new(job:, seeker: current_user.seeker).add_elevator_pitch(params[:elevator_pitch])
    end

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
