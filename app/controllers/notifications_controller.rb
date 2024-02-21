class NotificationsController < ApplicationController
  include Secured

  before_action :authorize

  def mark_read
    all_notifications = Notification.unread.where(user: current_user)

    all_notifications.update!(read_at: Time.now.utc.iso8601)

    all_notifications.each do |n|
      EventService.create!(
        event_schema: Events::NotificationMarkedRead::V1,
        aggregate_id: current_user.id,
        data: Messages::UntypedHashWrapper.build(
          notification_id: n.id
        )
      )
    end

    render json: { success: true }
  end
end
