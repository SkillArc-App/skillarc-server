class NotificationsController < ApplicationController
  include MessageEmitter
  include Secured

  before_action :authorize

  def mark_read
    all_notifications = Notification.unread.where(user: current_user)

    with_message_service do
      all_notifications.update!(read_at: Time.now.utc.iso8601)

      all_notifications.each do |n|
        message_service.create!(
          schema: Events::NotificationMarkedRead::V1,
          user_id: current_user.id,
          data: {
            notification_id: n.id
          }
        )
      end
    end

    render json: { success: true }
  end
end
