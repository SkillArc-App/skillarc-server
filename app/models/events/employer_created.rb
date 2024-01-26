module Events
  module EmployerCreated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::EMPLOYER_CREATED,
      version: 1
    )
  end
end
