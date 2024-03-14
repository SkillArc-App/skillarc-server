module Commands
  module ScreenApplicant
    V1 = Messages::Schema.build(
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Applicant,
      message_type: Messages::Types::Applications::SCREEN_APPLICANT,
      version: 1
    )
  end
end
