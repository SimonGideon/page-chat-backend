class CommentSerializer
  include JSONAPI::Serializer
  attributes :id, :discussion_id, :user_id, :body, :created_at
end
