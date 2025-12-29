class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :discussion_id, :user_id, :body, :parent_id, :created_at, :likes_count

  attribute :is_liked do |comment, params|
    if params[:current_user]
      # Check loaded association if available, or query
      if comment.association(:comment_likes).loaded?
        comment.comment_likes.any? { |like| like.user_id == params[:current_user].id }
      else
        comment.comment_likes.exists?(user_id: params[:current_user].id)
      end
    else
      false
    end
  end

  attribute :user do |comment|
    {
      id: comment.user.id,
      first_name: comment.user.first_name,
      last_name: comment.user.last_name,
      avatar_url: comment.user.avatar_url
    }
  end

  attribute :replies do |comment, params|
    CommentSerializer.new(comment.replies, { params: params }).serializable_hash[:data]&.map { |d| d[:attributes] } || []
  end
end
