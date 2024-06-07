module Invites
  class InvitesAggregator < MessageConsumer
    def reset_for_replay
      EmployerInvite.delete_all
    end

    on_message Events::EmployerInviteCreated::V1, :sync do |message|
      EmployerInvite.create!(
        id: message.aggregate.id,
        email: message.data.invite_email,
        first_name: message.data.first_name,
        last_name: message.data.last_name,
        employer_id: message.data.employer_id,
        employer_name: message.data.employer_name
      )
    end

    on_message Events::EmployerInviteAccepted::V2, :sync do |message|
      EmployerInvite.update!(
        message.aggregate.id,
        used_at: message.occurred_at
      )
    end
  end
end
