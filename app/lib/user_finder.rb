class UserFinder
  include EventEmitter

  def find_or_create(sub:, token:, auth_client:)
    u = User.find_by(sub:)

    return u if u

    info = auth_client.get_user_info(token)

    new_user = User.create!(
      id: SecureRandom.uuid,
      email: info['email'],
      email_verified: info['email_verified'],
      image: info['picture'],
      sub:
    )

    with_event_service do
      event_service.create!(
        user_id: new_user.id,
        event_schema: Events::UserCreated::V1,
        data: Events::UserCreated::Data::V1.new(
          first_name: new_user.first_name,
          last_name: new_user.last_name,
          email: new_user.email,
          sub: new_user.sub
        ),
        occurred_at: new_user.created_at
      )
    end

    new_user
  end
end
