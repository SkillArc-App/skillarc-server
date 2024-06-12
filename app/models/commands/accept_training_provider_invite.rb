module Commands
  module AcceptTrainingProviderInvite
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::ACCEPT_TRAINING_PROVIDER_INVITE,
      version: 1
    )
  end
end
