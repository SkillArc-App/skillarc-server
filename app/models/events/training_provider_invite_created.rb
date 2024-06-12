module Events
  module TrainingProviderInviteCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          invite_email String
          first_name String
          last_name String
          role_description String
          training_provider_id Uuid
          training_provider_name String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::TRAINING_PROVIDER_INVITE_CREATED,
      version: 1
    )
  end
end
