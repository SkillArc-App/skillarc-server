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
    end

    V1 = Messages::Schema.build(
      data: Data::V1,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Employer,
      message_type: Messages::Types::Employers::EMPLOYER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
