class NotificationSerializer
  include JSONAPI::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :action, :read_at, :created_at, :notifiable_type, :notifiable_id

  attribute :actor do |notification|
    {
      id: notification.actor.id,
      name: "#{notification.actor.first_name} #{notification.actor.last_name}",
      avatar_url: notification.actor.avatar_url
    }
  end

  attribute :message do |notification|
    actor_name = "#{notification.actor.first_name} #{notification.actor.last_name}"
    case notification.action
    when "liked_comment"
      "#{actor_name} liked your comment"
    when "replied_to_comment"
      "#{actor_name} replied to your comment"
    when "commented_on_discussion"
      "#{actor_name} commented on your discussion"
    else
      "New notification from #{actor_name}"
    end
  end

  # Helper to guide frontend routing
  attribute :redirect_info do |notification|
    case notification.notifiable_type
    when "Comment"
      comment = notification.notifiable
      {
        book_id: comment.discussion.book_id,
        discussion_id: comment.discussion_id,
        comment_id: comment.id,
        highlight_id: comment.id
      }
    when "CommentLike"
       # For likes, the notifiable is the Like, but we want to go to the Comment
       comment = notification.notifiable.comment
       {
         book_id: comment.discussion.book_id,
         discussion_id: comment.discussion_id,
         comment_id: comment.id,
         highlight_id: comment.id
       }
    when "Discussion"
      discussion = notification.notifiable
      {
        book_id: discussion.book_id,
        discussion_id: discussion.id,
        highlight_id: nil
      }
    else
      {}
    end
  end
end
