class NotificationsController < ApplicationController
  include Secured

  before_action :authorize

  def mark_read
    all_notifications = Notification.unread.where(user: current_user)

    all_notifications.update!(read_at: Time.now.utc.iso8601)

    all_notifications.each do |n|
      Resque.enqueue(
        CreateEventJob,
        event_type: Event::EventTypes::NOTIFICATIONS_MARKED_READ,
        aggregate_id: current_user.id,
        data: {
          notification_id: n.id
        },
        metadata: {},
        occurred_at: Time.now.utc.iso8601
      )
    end

    render json: { success: true }
  end
end
