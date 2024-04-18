module Commands
  module CancelScheduledCommand
    module MetaData
      class V1
        extend Messages::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL)
          requestor_id Either(String, nil)
        end
      end
    end

    V1 = Messages::Schema.active(
      data: Messages::Nothing,
      metadata: MetaData::V1,
      aggregate: Aggregates::Task,
      message_type: Messages::Types::Infrastructure::CANCEL_SCHEDULED_COMMAND,
      version: 1
    )
  end
end
