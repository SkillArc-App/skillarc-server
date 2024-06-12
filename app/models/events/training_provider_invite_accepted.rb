module Events
  module TrainingProviderInviteAccepted
    module Data
      class V1
        extend Messages::Payload

        schema do
          training_provider_invite_id Either(Uuid, nil), default: nil
          invite_email String
          training_provider_id Uuid
          training_provider_name String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          training_provider_profile_id Uuid
          user_id String
          invite_email String
          training_provider_id Uuid
          training_provider_name String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::TrainingProvider,
      message_type: Messages::Types::Invite::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Invite,
      message_type: Messages::Types::Invite::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 2
    )
  end
end
