module Jobs
  class TestimonialService
    def self.create(job_id:, name:, title:, testimonial:, photo_url:)
      t = Testimonial.create!(
        id: SecureRandom.uuid,
        job_id:,
        name:,
        title:,
        testimonial:,
        photo_url:
      )

      EventService.create!(
        event_schema: Events::TestimonialCreated::V1,
        aggregate_id: job_id,
        data: Events::TestimonialCreated::Data::V1.new(
          id: t.id,
          job_id:,
          name:,
          title:,
          testimonial:,
          photo_url:
        ),
        occurred_at: Time.current
      )

      t
    end

    def self.destroy(testimonial)
      testimonial.destroy!

      EventService.create!(
        event_schema: Events::TestimonialDestroyed::V1,
        aggregate_id: testimonial.job_id,
        data: Events::TestimonialDestroyed::Data::V1.new(
          id: testimonial.id
        ),
        occurred_at: Time.current
      )
    end
  end
end
