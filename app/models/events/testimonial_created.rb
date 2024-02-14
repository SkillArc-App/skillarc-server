module Events
  module TestimonialCreated
    module Data
      class V1
        extend Concerns::Payload

        schema do
          id Uuid
          job_id Uuid
          name String
          title String
          testimonial String
          photo_url String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::TESTIMONIAL_CREATED,
      version: 1
    )
  end
end
