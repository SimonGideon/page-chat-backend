module Mentionable
  extend ActiveSupport::Concern

  included do
    after_create :notify_mentioned_users
    # Store mentioned user IDs to avoid re-notifying (optional, simplistic for now)
  end

  private

  def notify_mentioned_users
    return unless respond_to?(:body) && body.present?

    # Regex to find @[Name](id)
    # Pattern: @\[([^\]]+)\]\((\d+)\)
    # Group 1: Name, Group 2: ID
    mentions = body.scan(/@\[([^\]]+)\]\((\d+)\)/)

    mentions.each do |match|
      name, id = match
      recipient = User.find_by(id: id)
      
      next unless recipient
      next if recipient.id == user_id # Don't notify self

      Notification.create(
        recipient: recipient,
        actor: user,
        action: "mentioned_in_#{self.class.name.underscore}",
        notifiable: self
      )
    end
  end
end
