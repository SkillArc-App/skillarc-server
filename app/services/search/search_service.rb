module Search
  class SearchService < MessageConsumer
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
        metadata = Events::JobSearch::MetaData::V2.new(
          source:,
          id: user.id,
          utm_source:
        )
      else
        search_id = "unauthenticated"
        metadata = Events::JobSearch::MetaData::V2.new(
          source: "unauthenticated",
          utm_source:
        )
      end

      EventService.create!(
        event_schema: Events::JobSearch::V2,
        data: Events::JobSearch::Data::V1.new(
          search_terms:,
          industries:,
          tags:
        ),
        search_id:,
        metadata:
      )
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
          starting_pay: {
            employment_type: job.employment_type,
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
      employer_logo_url = Employer.find_by(id: data.employer_id)&.logo_url

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
      tag = Tag.find(message.data.tag_id)

      job.update!(tags: job.tags.to_set.add(tag.name).to_a)
    end

    on_message Events::JobTagDestroyed::V2 do |message|
      job = Job.find_by!(job_id: message.aggregate.job_id)
      tag = Tag.find(message.data.tag_id)

      job.update!(tags: job.tags.to_set.delete(tag).to_a)
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

    on_message Events::CareerPathUpdated::V1 do |message|
      data = message.data
      return unless data.order&.zero?

      job = Job.find_by!(job_id: message.job_id)

      job.update!(
        starting_lower_pay: data.lower_limit.to_i,
        starting_upper_pay: data.upper_limit.to_i
      )
    end

    on_message Events::ApplicantStatusUpdated::V5 do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      application = Application.find_or_initialize_by(application_id: data.applicant_id, search_job: job)

      application.update!(
        status: data.status,
        job_id: data.job_id,
        seeker_id: data.seeker_id
      )
    end

    on_message Events::ElevatorPitchCreated::V1 do |message|
      data = message.data
      application = Application.find_by!(job_id: data.job_id, seeker_id: message.aggregate.seeker_id)

      application.update!(elevator_pitch: data.pitch)
    end

    on_message Events::JobSaved::V1 do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      SavedJob.find_or_create_by(search_job_id: job.id, user_id: message.aggregate.user_id)
    end

    on_message Events::JobUnsaved::V1 do |message|
      data = message.data
      job = Job.find_by!(job_id: data.job_id)
      SavedJob.find_by(search_job_id: job.id, user_id: message.aggregate.user_id)&.destroy
    end
  end
end
