class Notification < ApplicationRecord
  # Who receives the notification
  belongs_to :recipient, class_name: "User"

  # Who triggered the action
  belongs_to :actor, class_name: "User"

  # What the notification is about (Comment, Discussion, etc.)
  belongs_to :notifiable, polymorphic: true

  # Validations
  validates :recipient_id, presence: true
  validates :actor_id, presence: true
  validates :action, presence: true
  validates :notifiable_type, presence: true
  validates :notifiable_id, presence: true

  after_create_commit :send_email_notification, :broadcast_notification

  private

  def broadcast_notification
    ActionCable.server.broadcast(
      "notifications_#{recipient_id}",
      NotificationSerializer.new(self).serializable_hash[:data][:attributes]
    )
  end

  def send_email_notification
    return unless recipient.email_notifications?
    NotificationMailer.with(notification: self).new_notification.deliver_now
  rescue => e
    Rails.logger.error("Failed to send notification email: #{e.message}")
  end

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :read,   -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # Helpers
  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def mark_as_unread!
    update!(read_at: nil)
  end
end
