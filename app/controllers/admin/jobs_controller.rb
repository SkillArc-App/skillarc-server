module Admin # rubocop:disable Metrics/ModuleLength
  class JobsController < AdminController
    include MessageEmitter

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

    def show
      job = Job.find(params[:id])

      render json: serialize_job_for_show(job)
    end

    def create
      with_message_service do
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
    end

    def update
      job = Job.find(params[:id])

      with_message_service do
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
  end

  private

  def serialize_job_for_show(job)
    {
      **job.slice(
        :id,
        :benefits_description,
        :responsibilities_description,
        :employment_title,
        :location,
        :employment_type,
        :hide_job,
        :schedule,
        :work_days,
        :requirements_description,
        :created_at,
        :category
      ).as_json,
      employer: {
        **job.employer.slice(
          :id,
          :name,
          :location,
          :bio,
          :logo_url,
          :created_at
        ).as_json
      },
      industry: job.industry || [],
      learned_skills: job.learned_skills.map do |ls|
        {
          id: ls.id,
          master_skill: serialize_master_skill(ls.master_skill)
        }
      end.as_json,
      desired_skills: job.desired_skills.map do |ds|
        {
          id: ds.id,
          master_skill: serialize_master_skill(ds.master_skill)
        }
      end.as_json,
      desired_certifications: job.desired_certifications.map do |dc|
        {
          id: dc.id,
          master_certification: serialize_master_certification(dc.master_certification)
        }
      end,
      career_paths: job.career_paths.map { |cp| serialize_career_path(cp) },
      job_attributes: job.job_attributes.map { |ja| serialize_job_attribute(ja) },
      job_photos: job.job_photos.map { |jp| serialize_job_photo(jp) },
      job_tag: job.job_tags.map do |jt|
        {
          id: jt.id,
          tag: {
            id: jt.tag.id,
            name: jt.tag.name
          }
        }
      end,
      number_of_applicants: job.applicants.length,
      testimonials: job.testimonials.map { |t| serialize_testimonial(t) }
    }
  end

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

  def serialize_job_attribute(job_attribute)
    job_attribute.slice(:id, :acceptible_set, :attribute_id, :attribute_name)
  end

  def serialize_master_skill(master_skill)
    master_skill.slice(:id, :skill, :type)
  end

  def serialize_master_certification(master_certification)
    master_certification.slice(:id, :certification)
  end

  def serialize_career_path(career_paths)
    career_paths.slice(:id, :title, :upper_limit, :lower_limit, :order)
  end

  def serialize_job_photo(job_photo)
    job_photo.slice(:id, :photo_url, :job_id)
  end

  def serialize_testimonial(testimonial)
    testimonial.slice(:id, :name, :title, :testimonial, :photo_url)
  end
end
