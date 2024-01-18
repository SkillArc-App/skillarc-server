module Klayvio
  class TrainingProviderInviteAccepted
    def call(event:)
      Klayvio.new.training_provider_invite_accepted(
        event_id: event.id,
        email: event.data[:invite_email],
        profile_properties: {
          is_training_provider: true,
          training_provider_name: event.data[:training_provider_name],
          training_provider_id: event.data[:training_provider_id]
        },
        occurred_at: event.occurred_at
      )
    end
  end
end
