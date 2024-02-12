module Klayvio
  class TrainingProviderInviteAccepted
    include DefaultStreamId

    def call(message:)
      Klayvio.new.training_provider_invite_accepted(
        event_id: message.id,
        email: message.data[:invite_email],
        profile_properties: {
          is_training_provider: true,
          training_provider_name: message.data[:training_provider_name],
          training_provider_id: message.data[:training_provider_id]
        },
        occurred_at: message.occurred_at
      )
    end
  end
end
