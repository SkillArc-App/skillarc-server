module Commands
  module ScreenApplicant
    V1 = Core::Schema.active(
      type: Core::COMMAND,
      data: Core::Nothing,
      metadata: Core::Nothing,
      aggregate: Aggregates::Application,
      message_type: MessageTypes::Applications::SCREEN_APPLICANT,
      version: 1
    )
  end
end
