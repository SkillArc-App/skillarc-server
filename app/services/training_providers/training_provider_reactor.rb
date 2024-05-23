module TrainingProviders
  class TrainingProviderReactor < MessageReactor
    def can_replay?
      true
    end

    def create_reference(reference_text:, seeker_id:, author_training_provider_profile_id:, trace_id:)
      message_service.create!(
        schema: Events::ReferenceCreated::V1,
        reference_id: SecureRandom.uuid,
        data: {
          reference_text:,
          author_training_provider_profile_id:,
          seeker_id:
        },
        trace_id:
      )
    end

    def update_reference(reference_id:, reference_text:, trace_id:)
      message_service.create!(
        schema: Events::ReferenceUpdated::V1,
        reference_id:,
        trace_id:,
        data: {
          reference_text:
        }
      )
    end
  end
end
