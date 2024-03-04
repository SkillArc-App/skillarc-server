class HookService
  def create_notification(email:, title:, body:, url:)
    user = User.find_by!(email:)

    EventService.create!(
      event_schema: Events::NotificationCreated::V1,
      user_id: user.id,
      data: Messages::UntypedHashWrapper.build(
        title:,
        body:,
        url:
      )
    )
  end
end
