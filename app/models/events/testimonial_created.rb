module Events
  module TestimonialCreated
    module Data
      class V1
        extend Messages::Payload

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

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Job,
      message_type: Messages::Types::Jobs::TESTIMONIAL_CREATED,
      version: 1
    )
  end
end
