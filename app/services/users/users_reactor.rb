module Users
  class UsersReactor < MessageReactor
    def can_replay?
      true
    end

    on_message Events::RoleAdded::V2 do |message|
      return unless message.data.role == Role::Types::COACH

      user_created = Projectors::Streams::GetFirst.project(
        stream: message.stream,
        schema: Events::UserCreated::V1
      )

      return if user_created&.data&.email.nil?

      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: Events::CoachAdded::V1,
        user_id: message.stream.id,
        data: {
          coach_id: SecureRandom.uuid,
          email: user_created.data.email
        }
      )
    end

    on_message Events::UserCreated::V1 do |message|
      message_service.create_once_for_stream!(
        trace_id: message.trace_id,
        schema: ::Commands::SendSlackMessage::V2,
        message_id: message.deterministic_uuid,
        data: {
          channel: "#feed",
          text: "New user signed up: *#{message.data.email}*"
        }
      )
    end

    on_message Commands::Contact::V1, :sync do |message|
      return unless message_service.query.by_stream(People::Streams::Person.new(person_id: message.data.person_id)).by_schema(People::Events::PersonAdded::V1).exists?

      message_service.create_once_for_trace!(
        schema: Events::Contacted::V1,
        trace_id: message.trace_id,
        stream: message.stream,
        data: {
          person_id: message.data.person_id,
          note: message.data.note,
          contact_direction: message.data.contact_direction,
          contact_type: message.data.contact_type
        }
      )
    end
  end
end
