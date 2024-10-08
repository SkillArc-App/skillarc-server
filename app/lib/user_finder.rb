class UserFinder
  include MessageEmitter

  def find_or_create(sub:, token:, auth_client:)
    user = User.find_by(sub:)

    if user.present?
      Sentry.set_user(email: user.email, id: user.id, person_id: user.person_id)
      return user
    end

    info = auth_client.get_user_info(token)

    begin
      new_user = User.create!(
        id: SecureRandom.uuid,
        email: info['email'],
        email_verified: info['email_verified'],
        image: info['picture'],
        sub:
      )

      with_message_service do
        message_service.create!(
          user_id: new_user.id,
          schema: Users::Events::UserCreated::V1,
          data: {
            first_name: new_user.first_name,
            last_name: new_user.last_name,
            email: new_user.email,
            sub: new_user.sub
          },
          occurred_at: new_user.created_at
        )
      end

      Sentry.set_user(email: new_user.email, id: new_user.id)
      new_user
    rescue ActiveRecord::RecordNotUnique
      # We had a race condition and a user was created
      # after the find occurred
      User.find_by!(sub:)
    end
  end
end
