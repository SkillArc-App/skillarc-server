module Commands
  module CancelTask
    module MetaData
      class V1
        extend Core::Payload

        schema do
          requestor_type Either(*Requestor::Kinds::ALL)
          requestor_id Either(String, nil)
        end
      end
    end

    V1 = Core::Schema.active(
      type: Core::COMMAND,
      data: Core::Nothing,
      metadata: MetaData::V1,
      aggregate: Aggregates::Task,
      message_type: MessageTypes::Infrastructure::CANCEL_TASK,
      version: 1
    )
  end
end
