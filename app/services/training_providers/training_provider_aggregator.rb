module TrainingProviders
  class TrainingProviderAggregator < MessageConsumer
    def reset_for_replay
      Reference.delete_all
    end

    on_message Events::ReferenceCreated::V1, :sync do |message|
      training_provider_profile = TrainingProviderProfile.find(
        message.data.author_training_provider_profile_id
      )

      Reference.create!(
        id: message.aggregate.id,
        reference_text: message.data.reference_text,
        author_profile_id: training_provider_profile.id,
        training_provider_id: training_provider_profile.training_provider_id,
        seeker_id: message.data.seeker_id
      )
    end

    on_message Events::ReferenceUpdated::V1, :sync do |message|
      reference = Reference.find(message.aggregate.id)
      reference.update!(reference_text: message.data.reference_text)
    end
  end
end
