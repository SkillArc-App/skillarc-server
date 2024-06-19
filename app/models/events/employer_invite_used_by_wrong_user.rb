module Events
  module EmployerInviteUsedByWrongUser
    module Data
      class V1
        extend Core::Payload

        schema do
          user_id String
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::EVENT,
      data: Data::V1,
      metadata: Core::Nothing,
      aggregate: Aggregates::Invite,
      message_type: MessageTypes::Invite::EMPLOYER_INVITE_USED_BY_WRONG_USER,
      version: 1
    )
  end
end
