class NotificationService
  def call(event:)
    user = User.find_by!(email: event.data["email"])

    Notification.create!(
      user:,
      title: event.data["title"],
      body: event.data["body"],
      url: event.data["url"],
    )
  end
end