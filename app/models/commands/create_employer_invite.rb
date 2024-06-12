module Commands
  module CreateEmployerInvite
    module Data
      class V1
        extend Messages::Payload

        schema do
          invite_email String
          first_name String
          last_name String
          employer_id Uuid
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::CREATE_EMPLOYER_INVITE,
      version: 1
    )
  end
end
