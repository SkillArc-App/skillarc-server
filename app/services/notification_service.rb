class NotificationService
  def call(event:)
    user = User.find(event.aggregate_id)

    Notification.create!(
      user:,
      title: event.data["title"],
      body: event.data["body"],
      url: event.data["url"],
    )
  end
end