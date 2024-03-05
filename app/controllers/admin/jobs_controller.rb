module Admin
  class JobsController < AdminController
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

      render json: jobs.map { |job| serialize_job(job) }
    end

    def create
      job = Jobs::JobService.new.create(
        **params.require(:job).permit(
          :category,
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
            :category,
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
  end

  private

  def serialize_job(job)
    {
      **job.as_json,
      industry: job.industry || [],
      employer: job.employer.as_json,
      learned_skills: job.learned_skills.map do |ls|
        {
          **ls.as_json,
          master_skill: ls.master_skill.as_json
        }
      end.as_json,
      desired_skills: job.desired_skills.map do |ds|
        {
          **ds.as_json,
          master_skill: ds.master_skill.as_json
        }
      end.as_json,
      desired_certifications: job.desired_certifications.map do |dc|
        {
          **dc.as_json,
          master_certification: dc.master_certification.as_json
        }
      end,
      career_paths: job.career_paths.as_json,
      job_photos: job.job_photos.as_json,
      job_tag: job.job_tags.map do |jt|
        {
          **jt.as_json,
          tag: jt.tag.as_json
        }
      end.as_json,
      number_of_applicants: job.applicants.length,
      testimonials: job.testimonials.as_json
    }
  end
end
