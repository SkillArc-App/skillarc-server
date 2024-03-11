class TrainingProviderInviteService
  include EventEmitter

  def initialize(invite)
    @invite = invite
  end

  def accept
    event_service.create!(
      event_schema: Events::TrainingProviderInviteAccepted::V1,
      training_provider_id: invite.training_provider_id,
      data: Events::TrainingProviderInviteAccepted::Data::V1.new(
        training_provider_invite_id: invite.id,
        invite_email: invite.email,
        training_provider_id: invite.training_provider_id,
        training_provider_name: invite.training_provider.name
      )
    )

    user = User.find_by!(email: invite.email)

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
