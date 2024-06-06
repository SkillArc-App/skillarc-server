module Events
  module EmployerInviteAccepted
    module Data
      class V1
        extend Messages::Payload

        schema do
          employer_invite_id Uuid
          invite_email String
          employer_id Uuid
          employer_name String
        end
      end

      class V2
        extend Messages::Payload

        schema do
          user_id String
          invite_email String
          employer_id Uuid
          employer_name String
        end
      end
    end

    V1 = Messages::Schema.inactive(
      type: Messages::EVENT,
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Employer,
      message_type: Messages::Types::Invite::EMPLOYER_INVITE_ACCEPTED,
      version: 1
    )
    V2 = Messages::Schema.active(
      type: Messages::EVENT,
      data: Data::V2,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Invite,
      message_type: Messages::Types::Invite::EMPLOYER_INVITE_ACCEPTED,
      version: 2
    )
  end
end
