class HookService
  def create_notification(email:, title:, body:, url:)
    user = User.find_by(email:)

    EventService.create!(
      event_type: Event::EventTypes::NOTIFICATION_CREATED,
      aggregate_id: user.id,
      data: {
        title:,
        body:,
        url:
      }
    )
  end
end
