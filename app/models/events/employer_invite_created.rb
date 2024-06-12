module Events
  module EmployerInviteCreated
    module Data
      class V1
        extend Messages::Payload

        schema do
          invite_email String
          first_name String
          last_name String
          employer_id Uuid
          employer_name String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::EMPLOYER_INVITE_CREATED,
      version: 1
    )
  end
end
