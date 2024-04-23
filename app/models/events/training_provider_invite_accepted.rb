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
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::TrainingProvider,
      message_type: Messages::Types::TRAINING_PROVIDER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
