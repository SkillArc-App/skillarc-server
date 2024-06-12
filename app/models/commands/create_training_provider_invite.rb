module Commands
  module CreateTrainingProviderInvite
    module Data
      class V1
        extend Messages::Payload

        schema do
          invite_email String
          first_name String
          last_name String
          role_description String
          training_provider_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::CREATE_TRAINING_PROVIDER_INVITE,
      version: 1
    )
  end
end
