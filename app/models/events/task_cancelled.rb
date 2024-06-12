module Events
  module TaskCancelled
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
      type: Messages::EVENT,
      data: Messages::Nothing,
      metadata: MetaData::V1,
      stream: Streams::Task,
      message_type: Messages::Types::Infrastructure::TASK_CANCELLED,
      version: 1
    )
  end
end
