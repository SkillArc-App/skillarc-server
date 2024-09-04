module People
  class PersonAttributeReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::AddPersonAttribute::V2 do |message|
      # Make sure the stream exists
      return unless message_service.query.by_stream(message.stream).by_schema(Events::PersonAdded::V1).exists?

      return if message.data.attribute_value_ids.length != message.data.attribute_value_ids.to_set.length

      message_service.create_once_for_trace!(
        schema: Events::PersonAttributeAdded::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: message.data.id,
          attribute_id: message.data.attribute_id,
          attribute_value_ids: message.data.attribute_value_ids
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
      attribute_value_ids = select_attribute_ids(Attributes::INDUSTRIES_STREAM.attribute_id, message.data.interests)

      return if attribute_value_ids.empty?

      message_service.create_once_for_trace!(
        schema: Commands::AddPersonAttribute::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: SecureRandom.uuid,
          attribute_id: Attributes::INDUSTRIES_STREAM.attribute_id,
          attribute_value_ids:
        }
      )
    end

    on_message Events::PersonTrainingProviderAdded::V1 do |message|
      training_provider_name = ::Projectors::Streams::GetFirst.project(
        schema: ::Events::TrainingProviderCreated::V1,
        stream: ::Streams::TrainingProvider.new(training_provider_id: message.data.training_provider_id)
      ).data.name

      attribute_value_ids = select_attribute_ids(Attributes::TRAINING_PROVIDER_STREAM.attribute_id, [training_provider_name])
      return if attribute_value_ids.empty?

      message_service.create_once_for_trace!(
        schema: Commands::AddPersonAttribute::V2,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          id: SecureRandom.uuid,
          attribute_id: Attributes::TRAINING_PROVIDER_STREAM.attribute_id,
          attribute_value_ids:
        }
      )
    end

    private

    def select_attribute_ids(attribute_id, attribute_values)
      messages = message_service.query.by_stream(Attributes::Streams::Attribute.new(attribute_id:)).fetch
      attribute_state = Attributes::Projectors::CurrentState.new.project(messages)

      attribute_state.set.select { |element| attribute_values.include?(element.value) }.map(&:key)
    end
  end
end
