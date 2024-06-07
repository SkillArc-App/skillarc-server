module Commands
  module AcceptEmployerInvite
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
      aggregate: Aggregates::Invite,
      message_type: Messages::Types::Invite::ACCEPT_EMPLOYER_INVITE,
      version: 1
    )
  end
end
