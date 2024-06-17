module JobSearch
  class JobSearchAggregator < MessageConsumer # rubocop:disable Metrics/ClassLength
    include MessageEmitter

    def reset_for_replay
      SavedJob.delete_all
      Application.delete_all
      Job.delete_all
    end

    def search(search_terms:, industries:, tags:, user:, utm_source:)
      query = Job.shown.includes(
        :applications,
        :saved_jobs
      )

      query = query.where("lower(employment_title) LIKE ? OR lower(employer_name) LIKE ?", "%#{search_terms.downcase}%", "%#{search_terms.downcase}%") if search_terms_usable?(search_terms)
      query = query.where("industries && ARRAY[?]::character varying[]", industries) if industries_usable?(industries)
      query = query.where("tags && ARRAY[?]::character varying[]", tags) if tags_usable?(tags)

      emit_event(search_terms, industries, tags, user, utm_source)

      serialize(query, user)
    end

    private

    def emit_event(search_terms, industries, tags, user, utm_source)
      if user.present?
        source = if user.seeker.present?
                   "seeker"
                 else
                   "user"
                 end

        search_id = user.id
        metadata = {
          source:,
          id: user.id,
          utm_source:
        }
      else
        search_id = "unauthenticated"
        metadata = {
          source: "unauthenticated",
          utm_source:
        }
      end

      with_message_service do
        message_service.create!(
          schema: Events::JobSearch::V2,
          data: {
            search_terms:,
            industries:,
            tags:
          },
          search_id:,
          metadata:
        )
      end
    end

    def search_terms_usable?(search_terms)
      search_terms.present? && search_terms.length >= 3
    end

    def industries_usable?(industries)
      industries.present?
    end

    def tags_usable?(tags)
      tags.present?
    end

    def serialize(query, user)
      user_id = user&.id
      seeker_id = user&.seeker&.id

      query.order(category: :desc).map do |job|
        aplication = nil
        saved = nil

        saved = job.saved_jobs.any? { |sj| sj.user_id == user_id } if user_id.present?
        aplication = job.applications.detect { |a| a.seeker_id == seeker_id } if seeker_id.present?

        {
          id: job.job_id,
          category: job.category,
          employment_title: job.employment_title,
          industries: job.industries,
          location: job.location,
          starting_pay: job.starting_upper_pay && {
            employment_type: job.starting_lower_pay.to_i > 1000 ? "salary" : "hourly",
            upper_limit: job.starting_upper_pay,
            lower_limit: job.starting_lower_pay
          },
          tags: job.tags,
          application_status: aplication&.status,
          elevator_pitch: aplication&.elevator_pitch,
          saved:,
          employer: {
            id: job.employer_id,
            name: job.employer_name,
            logo_url: job.employer_logo_url
          }
        }
      end
    end

    on_message Events::JobCreated::V3 do |message|
      data = message.data

      employer_logo_url = Projectors::Aggregates::GetFirst.project(
        schema: Events::EmployerCreated::V1,
        aggregate: Aggregates::Employer.new(employer_id: data.employer_id)
      )&.data&.logo_url

      Job.create!(
        category: data.category,
        employer_logo_url:,
        employment_title: data.employment_title,
        employment_type: data.employment_type,
        employer_name: data.employer_name,
        hidden: data.hide_job,
        location: data.location,
        industries: data.industry,
        job_id: message.aggregate.job_id,
        employer_id: data.employer_id
      )
    end

    on_message Events::JobUpdated::V2 do |message|
      job = Job.find_by!(job_id: message.aggregate.job_id)

      data = message.data
      job.update!(
        category: data.category,
        employment_title: data.employment_title,
        employment_type: data.employment_type,
        hidden: data.hide_job,
        location: data.location,
        industries: data.industry,
        job_id: message.aggregate.job_id
      )
    end

    on_message Events::JobTagCreated::V1 do |message|
      job = Job.find_by!(job_id: message.aggregate.job_id)

      tag_name = Projectors::Aggregates::GetFirst.project(
        schema: Events::TagCreated::V1,
        aggregate: Aggregates::Tag.new(tag_id: message.data.tag_id)
      ).data.name

      job.update!(tags: job.tags.to_set.add(tag_name).to_a)
    end

    on_message Events::JobTagDestroyed::V2 do |message|
      job = Job.find_by!(job_id: message.aggregate.job_id)
      tag_name = Projectors::Aggregates::GetFirst.project(
        schema: Events::TagCreated::V1,
        aggregate: Aggregates::Tag.new(tag_id: message.data.tag_id)
      ).data.name

      job.update!(tags: job.tags.to_set.delete(tag_name).to_a)
    end

    on_message Events::CareerPathCreated::V1 do |message|
      data = message.data
      return unless data.order.zero?

      job = Job.find_by!(job_id: message.aggregate.job_id)

      job.update!(
        starting_lower_pay: data.lower_limit.to_i,
        starting_upper_pay: data.upper_limit.to_i
      )
    end

    on_message Events::ApplicantStatusUpdated::V6, :sync do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      application = Application.find_or_initialize_by(application_id: message.aggregate.application_id, search_job: job)

      application.update!(
        status: data.status,
        job_id: data.job_id,
        seeker_id: data.seeker_id
      )
    end

    on_message Events::ElevatorPitchCreated::V2, :sync do |message|
      data = message.data
      application = Application.find_by(job_id: data.job_id, seeker_id: message.aggregate.id)
      return unless application

      application.update!(elevator_pitch: data.pitch)
    end

    on_message Events::JobSaved::V1, :sync do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      SavedJob.find_or_create_by(search_job_id: job.id, user_id: message.aggregate.user_id)
    end

    on_message Events::JobUnsaved::V1, :sync do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      SavedJob.find_by(search_job_id: job.id, user_id: message.aggregate.user_id)&.destroy
    end
  end
end
