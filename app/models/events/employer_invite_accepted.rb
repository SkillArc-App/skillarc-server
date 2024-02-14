module Events
  module EmployerInviteAccepted
    module Data
      class V1
        extend Payload

        schema do
          employer_invite_id Uuid
          invite_email String
          employer_id Uuid
          employer_name String
        end
      end
    end

    V1 = Schema.build(
      data: Data::V1,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EMPLOYER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
