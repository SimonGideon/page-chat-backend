class Comment < ApplicationRecord
  include ProfanityFilterable
  belongs_to :discussion, counter_cache: true
  belongs_to :user
  belongs_to :parent, class_name: "Comment", optional: true
  
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :reports, as: :reportable, dependent: :destroy

  enum status: { active: 0, flagged: 1, hidden: 2 }


  belongs_to :deleted_by, class_name: "User", optional: true

  def soft_delete!(actor, reason: "deleted by author")
    update!(
      deleted: true,
      deleted_at: Time.current,
      deleted_by: actor,
      deletion_reason: reason,
      body: nil
    )
  end

  def deleted_placeholder
    "This comment was deleted"
  end

  def display_body
    deleted? ? deleted_placeholder : body
  end

  validates :user, presence: true
  validates :body, presence: true

  after_create :notify_recipient

  private

  def notify_recipient
    if parent_id.present?
      # Reply: Notify parent comment author
      return if user_id == parent.user_id # Don't notify self
      Notification.create(
        recipient: parent.user,
        actor: user,
        action: "replied_to_comment",
        notifiable: self
      )
    else
      # Discussion Comment: Notify discussion author
      return if user_id == discussion.user_id # Don't notify self
      Notification.create(
        recipient: discussion.user,
        actor: user,
        action: "commented_on_discussion",
        notifiable: self
      )
    end
  end
end
