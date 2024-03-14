module Events
  module ApplicantScreened
    V1 = Messages::Schema.build(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Applicant,
      message_type: Messages::Types::Applications::APPLICANT_SCREENED,
      version: 1
    )
  end
end
