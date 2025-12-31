# frozen_string_literal: true

class CommentLike < ApplicationRecord
  belongs_to :comment, counter_cache: :likes_count
  belongs_to :user

  validates :comment_id, uniqueness: { scope: :user_id }

  after_create :notify_recipient

  private

  def notify_recipient
    return if user_id == comment.user_id # Don't notify self
    Notification.create(
      recipient: comment.user,
      actor: user,
      action: "liked_comment",
      notifiable: self
    )
  end
end
