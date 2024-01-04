class HookService
  def create_notification(email:, title:, body:, url:)
    user = User.find_by(email:)

    Resque.enqueue(
      CreateEventJob,
      event_type: Event::EventTypes::NOTIFICATION_CREATED,
      aggregate_id: user.id,
      data: {
        title:,
        body:,
        url:
      },
      occurred_at: Time.now.utc.iso8601,
      metadata: {}
    )
  end
end
