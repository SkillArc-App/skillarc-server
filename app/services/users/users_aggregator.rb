module Users
  class UsersAggregator < MessageConsumer
    def reset_for_replay
      UserRole.delete_all
    end

    on_message Events::PersonAssociatedToUser::V1 do |message|
      user = User.find(message.data.user_id)

      user.update!(person_id: message.aggregate.id)
    end

    on_message Events::RoleAdded::V2 do |message|
      user = User.find(message.aggregate.id)

      return if user.role?(message.data.role)

      role = Role.find_by!(name: message.data.role)

      UserRole.create!(
        id: SecureRandom.uuid,
        role:,
        user:
      )
    end
  end
end
