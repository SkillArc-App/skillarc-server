module Users
  class UsersReactor < MessageConsumer
    def reset_for_replay
      UserRole.delete_all
    end

    on_message Events::RoleAdded::V2 do |message|
      return unless message.data.role == Role::Types::COACH

      user_created = Projections::GetFirst.project(
        aggregate: message.aggregate,
        schema: Events::UserCreated::V1
      )

      return if user_created&.data&.email.nil?

      message_service.create_once!(
        trace_id: message.trace_id,
        schema: Events::CoachAdded::V1,
        user_id: message.aggregate.id,
        data: {
          coach_id: SecureRandom.uuid,
          email: user_created.data.email
        }
      )
    end
  end
end
