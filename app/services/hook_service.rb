class HookService
  def create_notification(email:, title:, body:, url:)
    user = User.find_by(email:)

    EventService.create!(
      event_schema: Events::NotificationCreated::V1,
      aggregate_id: user.id,
      data: Events::Common::UntypedHashWrapper.new(
        title:,
        body:,
        url:
      )
    )
  end
end
