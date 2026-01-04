module Api
  module V1
    class NotificationsController < ApplicationController
      before_action :authenticate_user!

      def index
        notifications = current_user.notifications.unread.recent.page(params[:page]).per(20)
        json = NotificationSerializer.new(notifications).serializable_hash
        render json: {
          data: json[:data].map { |d| d[:attributes] },
          meta: {
            unread_count: current_user.notifications.unread.count,
            total_pages: notifications.total_pages,
            current_page: notifications.current_page
          }
        }
      end

      def mark_as_read
        notification = current_user.notifications.find(params[:id])
        notification.mark_as_read!
        render json: { status: "success", message: "Notification marked as read" }
      end

      def mark_all_as_read
        current_user.notifications.unread.update_all(read_at: Time.current)
        render json: { status: "success", message: "All notifications marked as read" }
      end
    end
  end
end
