module Events
  module EmployerUpdated
    V1 = Schema.build(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EMPLOYER_UPDATED,
      version: 1
    )
  end
end
