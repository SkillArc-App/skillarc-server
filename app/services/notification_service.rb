class NotificationService
  include DefaultStreamId

  def call(message:)
    Contact::Notification.create!(
      user_id: message.aggregate_id,
      title: message.data[:title],
      body: message.data[:body],
      url: message.data[:url]
    )
  end
end
