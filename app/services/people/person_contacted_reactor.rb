module People
  class PersonContactedReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Commands::Contact::V1 do |message|
      return unless message_service.query.by_stream(Streams::Person.new(person_id: message.data.from_person_id)).by_schema(Events::PersonAdded::V1).exists?
      return unless message_service.query.by_stream(Streams::Person.new(person_id: message.data.to_person_id)).by_schema(Events::PersonAdded::V1).exists?

      message_service.create_once_for_trace!(
        schema: Events::Contacted::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          from_person_id: message.data.from_person_id,
          to_person_id: message.data.to_person_id,
          note: message.data.note,
          contact_type: message.data.contact_type
        }
      )
    end
  end
end
