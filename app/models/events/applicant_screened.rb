module Events
  module ApplicantScreened
    V1 = Messages::Schema.active(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Application,
      message_type: Messages::Types::Applications::APPLICANT_SCREENED,
      version: 1
    )
  end
end
