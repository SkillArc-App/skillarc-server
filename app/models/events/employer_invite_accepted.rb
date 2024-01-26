module Events
  module EmployerInviteAccepted
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EMPLOYER_INVITE_ACCEPTED,
      version: 1
    )
  end
end
