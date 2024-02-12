class NotificationService
  include DefaultStreamId

  def call(message:)
    user = User.find(message.aggregate_id)

    Notification.create!(
      user:,
      title: message.data[:title],
      body: message.data[:body],
      url: message.data[:url]
    )
  end
end
