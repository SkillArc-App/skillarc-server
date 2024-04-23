module Commands
  module ScreenApplicant
    V1 = Messages::Schema.active(
      type: Messages::COMMAND,
      data: Messages::Nothing,
      metadata: Messages::Nothing,
      aggregate: Aggregates::Application,
      message_type: Messages::Types::Applications::SCREEN_APPLICANT,
      version: 1
    )
  end
end
