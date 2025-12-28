class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :discussion_id, :user_id, :body, :parent_id, :created_at

  attribute :user do |comment|
    {
      id: comment.user.id,
      first_name: comment.user.first_name,
      last_name: comment.user.last_name,
      avatar_url: comment.user.avatar_url
    }
  end

  attribute :replies do |comment|
    CommentSerializer.new(comment.replies).as_json['data']&.map { |d| d['attributes'] } || []
  end
end
