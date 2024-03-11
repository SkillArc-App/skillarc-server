class NotificationsController < ApplicationController
  include EventEmitter
  include Secured

  before_action :authorize

  def mark_read
    all_notifications = Notification.unread.where(user: current_user)

    with_event_service do
      all_notifications.update!(read_at: Time.now.utc.iso8601)

      all_notifications.each do |n|
        event_service.create!(
          event_schema: Events::NotificationMarkedRead::V1,
          user_id: current_user.id,
          data: Events::NotificationMarkedRead::Data::V1.new(
            notification_id: n.id
          )
        )
      end
    end

    render json: { success: true }
  end
end
