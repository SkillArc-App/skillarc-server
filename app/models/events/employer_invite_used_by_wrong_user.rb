module Events
  module EmployerInviteUsedByWrongUser
    module Data
      class V1
        extend Messages::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      stream: Streams::Invite,
      message_type: Messages::Types::Invite::EMPLOYER_INVITE_USED_BY_WRONG_USER,
      version: 1
    )
  end
end
