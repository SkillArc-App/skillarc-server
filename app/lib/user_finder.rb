class UserFinder
  def find_or_create(decoded_token, token, auth_client:)
    _, sub = decoded_token[0]['sub'].split('|')

    u = User.find_by(sub:)

    return u if u

    info = auth_client.get_user_info(token)

    new_user = User.create!(
      id: SecureRandom.uuid,
      email: info['email'],
      email_verified: info['email_verified'],
      image: info['picture'],
      name: info['nickname'],
      sub:
    )

    CreateEventJob.perform_later(
      aggregate_id: new_user.id,
      event_type: "user_created",
      data: {
        first_name: new_user.first_name,
        last_name: new_user.last_name,
        email: new_user.email,
        sub: new_user.sub
      },
      metadata: {},
      occurred_at: new_user.created_at
    )

    new_user
  end
end
