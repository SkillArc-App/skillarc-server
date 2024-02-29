module Events
  module JobUnsaved
    V1 = Messages::Schema.build(
      data: Messages::UntypedHashWrapper,
      metadata: Messages::Nothing,
      message_type: Messages::Types::Seekers::JOB_UNSAVED,
      version: 1
    )
  end
end
