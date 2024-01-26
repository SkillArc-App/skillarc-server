module Events
  module ApplicantStatusUpdated
    V1 = Schema.new(
      data: Common::UntypedHashWrapper,
      metadata: Common::Nothing,
      event_type: Event::EventTypes::APPLICANT_STATUS_UPDATED,
      version: 1
    )
  end
end
