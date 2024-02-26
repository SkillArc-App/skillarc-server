module Jobs
  class CareerPathService
    def self.create(job, title:, lower_limit:, upper_limit:)
      order = job.career_paths.count

      career_path = job.career_paths.create!(id: SecureRandom.uuid, title:, lower_limit:, upper_limit:, order:)

      EventService.create!(
        event_schema: Events::CareerPathCreated::V1,
        aggregate_id: job.id,
        data: Events::CareerPathCreated::Data::V1.new(
          id: career_path.id,
          job_id: job.id,
          title: career_path.title,
          lower_limit: career_path.lower_limit,
          upper_limit: career_path.upper_limit,
          order: career_path.order
        )
      )

      career_path
    end

    def self.up(career_path)
      return if career_path.order.zero?

      upper_career_path = career_path.job.career_paths.find_by!(order: career_path.order - 1)

      career_path.update!(order: career_path.order - 1)
      upper_career_path.update!(order: upper_career_path.order + 1)

      EventService.create!(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: upper_career_path.job_id,
        data: Events::CareerPathUpdated::Data::V1.new(
          id: upper_career_path.id,
          order: upper_career_path.order
        )
      )

      EventService.create!(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: career_path.job_id,
        data: Events::CareerPathUpdated::Data::V1.new(
          id: career_path.id,
          order: career_path.order
        )
      )
    end

    def self.down(career_path)
      return if career_path.order == career_path.job.career_paths.count - 1

      lower_career_path = career_path.job.career_paths.find_by!(order: career_path.order + 1)

      career_path.update!(order: career_path.order + 1)
      lower_career_path.update!(order: lower_career_path.order - 1)

      EventService.create!(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: lower_career_path.job_id,
        data: Events::CareerPathUpdated::Data::V1.new(
          id: lower_career_path.id,
          order: lower_career_path.order
        )
      )

      EventService.create!(
        event_schema: Events::CareerPathUpdated::V1,
        aggregate_id: career_path.job_id,
        data: Events::CareerPathUpdated::Data::V1.new(
          id: career_path.id,
          order: career_path.order
        )
      )
    end

    def self.destroy(career_path)
      career_path.destroy!

      paths = career_path.job.career_paths.where('"order" > ?', career_path.order)

      paths.each do |path|
        path.update!(order: path.order - 1)

        EventService.create!(
          event_schema: Events::CareerPathUpdated::V1,
          aggregate_id: path.job_id,
          data: Events::CareerPathUpdated::Data::V1.new(
            id: path.id,
            job_id: path.job_id,
            title: path.title,
            lower_limit: path.lower_limit,
            upper_limit: path.upper_limit,
            order: path.order
          )
        )
      end

      EventService.create!(
        event_schema: Events::CareerPathDestroyed::V1,
        aggregate_id: career_path.job_id,
        data: Events::CareerPathDestroyed::Data::V1.new(
          id: career_path.id
        )
      )
    end
  end
end
