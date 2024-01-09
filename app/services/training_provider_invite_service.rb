class TrainingProviderInviteService
  def initialize(invite)
    @invite = invite
  end

  def accept
    CreateEventJob.perform_later(
      event_type: Event::EventTypes::TRAINING_PROVIDER_INVITE_ACCEPTED,
      aggregate_id: invite.training_provider_id,
      data: {
        training_provider_invite_id: invite.id,
        invite_email: invite.email,
        training_provider_id: invite.training_provider_id,
        training_provider_name: invite.training_provider.name
      },
      occurred_at: Time.now.utc.iso8601,
      metadata: {}
    )

    user = User.find_by(email: invite.email)

    TrainingProviderProfile.transaction do
      TrainingProviderProfile.create!(
        id: SecureRandom.uuid,
        training_provider_id: invite.training_provider_id,
        user:
      )

      invite.update!(used_at: Time.now.utc)
    end
  end

  private

  attr_reader :invite
end
