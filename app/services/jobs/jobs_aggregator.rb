module Jobs
  class JobsAggregator < MessageConsumer
    def reset_for_replay
      JobAttribute.delete_all
    end

    on_message Events::JobAttributeCreated::V1, :sync do |message|
      JobAttribute.create!(
        id: message.data.id,
        job_id: message.aggregate.job_id,
        attribute_name: message.data.attribute_name,
        attribute_id: message.data.attribute_id,
        acceptible_set: message.data.acceptible_set
      )
    end

    on_message Events::JobAttributeUpdated::V1, :sync do |message|
      job_attribute = JobAttribute.find(message.data.id)

      job_attribute.update!(
        acceptible_set: message.data.acceptible_set
      )
    end

    on_message Events::JobAttributeDestroyed::V1, :sync do |message|
      JobAttribute.find(message.data.id).destroy!
    end
  end
end
