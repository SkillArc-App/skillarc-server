module People
  class PersonAttributeReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::AddPersonAttribute::V1 do |message|
      # Make sure the stream exists
      return unless message_service.query.by_stream(message.stream).by_schema(Events::PersonAdded::V1).exists?

      return if message.data.attribute_values.length != message.data.attribute_values.to_set.length

      message_service.create_once_for_trace!(
        schema: Events::PersonAttributeAdded::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: message.data.id,
          attribute_id: message.data.attribute_id,
          attribute_name: message.data.attribute_name,
          attribute_values: message.data.attribute_values
        }
      )
    end

    on_message Commands::RemovePersonAttribute::V1 do |message|
      messages = MessageService.stream_events(message.stream).select { |m| m.occurred_at <= message.occurred_at }

      # Confirm attribute is on person
      attribute = People::Projectors::Attributes.new.project(messages).attributes[message.data.id]
      return if attribute.nil?

      message_service.create_once_for_trace!(
        schema: Events::PersonAttributeRemoved::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: message.data.id
        }
      )
    end

    on_message Events::ProfessionalInterestsAdded::V2 do |message|
      message_service.create_once_for_trace!(
        schema: Commands::AddPersonAttribute::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: SecureRandom.uuid,
          attribute_id: Attributes::INDUSTRIES_STREAM.attribute_id,
          attribute_name: Industries::INDUSTRIES_NAME,
          attribute_values: message.data.interests
        }
      )
    end

    on_message Events::PersonTrainingProviderAdded::V1 do |message|
      training_provider_name = ::Projectors::Streams::GetFirst.project(
        schema: ::Events::TrainingProviderCreated::V1,
        stream: ::Streams::TrainingProvider.new(training_provider_id: message.data.training_provider_id)
      ).data.name

      message_service.create_once_for_trace!(
        schema: Commands::AddPersonAttribute::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: SecureRandom.uuid,
          attribute_id: Attributes::TRAINING_PROVIDER_STREAM.attribute_id,
          attribute_name: TrainingProviders::TRAINING_PROVIDER_ATTRIBUTE_NAME,
          attribute_values: [training_provider_name]
        }
      )
    end
  end
end
