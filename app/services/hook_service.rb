class HookService
  include MessageEmitter

  def create_notification(email:, title:, body:, url:)
    user = User.find_by!(email:)

    message_service.create!(
      schema: Events::NotificationCreated::V1,
      user_id: user.id,
      data: {
        title:,
        body:,
        url:
  }
    )
  end
end
