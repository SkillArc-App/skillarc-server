module Jobs
  class JobsReactor < MessageConsumer
    def reset_for_replay; end

    def create_job_attribute(job_id:, attribute_id:, acceptible_set:)
      attribute_name = Attributes::Attribute.find(attribute_id).name

      message_service.create!(
        schema: Events::JobAttributeCreated::V1,
        job_id:,
        data: {
          id: SecureRandom.uuid,
          attribute_name:,
          attribute_id:,
          acceptible_set:
        }
      )
    end

    def update_job_attribute(job_attribute_id:, acceptible_set:)
      job_attribute = JobAttribute.find(job_attribute_id)

      message_service.create!(
        schema: Events::JobAttributeUpdated::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id,
          acceptible_set:
        }
      )
    end

    def destroy_job_attribute(job_attribute_id:)
      job_attribute = JobAttribute.find(job_attribute_id)

      message_service.create!(
        schema: Events::JobAttributeDestroyed::V1,
        job_id: job_attribute.job_id,
        data: {
          id: job_attribute.id
        }
      )
    end
  end
end
