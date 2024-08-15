module TrainingProviders
  class TrainingProviderAttributeReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::TrainingProviderCreated::V1 do |message|
      names = Events::TrainingProviderCreated::V1.all_messages
                                                 .select { |m| m.occurred_at < message.occurred_at }
                                                 .map { |m| m.data.name }

      names << message.data.name

      message_service.create_once_for_trace!(
        schema: Attributes::Commands::Create::V1,
        trace_id: message.trace_id,
        stream: Attributes::TRAINING_PROVIDER_STREAM,
        data: {
          machine_derived: true,
          name: TRAINING_PROVIDER_ATTRIBUTE_NAME,
          description: "",
          set: names,
          default: []
        },
        metadata: {
          requestor_type: Requestor::Kinds::SERVER,
          requestor_id: nil
        }
      )
    end
  end
end
