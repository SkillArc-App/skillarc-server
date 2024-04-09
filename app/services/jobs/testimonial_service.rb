module Jobs
  class TestimonialService
    extend MessageEmitter

    def self.create(job_id:, name:, title:, testimonial:, photo_url:)
      t = Testimonial.create!(
        id: SecureRandom.uuid,
        job_id:,
        name:,
        title:,
        testimonial:,
        photo_url:
      )

      message_service.create!(
        schema: Events::TestimonialCreated::V1,
        job_id:,
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

      message_service.create!(
        schema: Events::TestimonialDestroyed::V1,
        job_id: testimonial.job_id,
        data: Events::TestimonialDestroyed::Data::V1.new(
          id: testimonial.id
        ),
        occurred_at: Time.current
      )
    end
  end
end
