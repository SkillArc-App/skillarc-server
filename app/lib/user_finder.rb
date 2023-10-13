class UserFinder
  def find_or_create(decoded_token, token)
    _, sub = decoded_token[0]['sub'].split('|')

    User.find_or_create_by!(sub:) do |u|
      info = Auth0Client.get_user_info(token)

      u.id = SecureRandom.uuid
      u.email = info['email']
      u.email_verified = info['email_verified']
      u.image = info['picture']
      u.name = info['nickname']
      u.sub = sub
    end
  end
end
