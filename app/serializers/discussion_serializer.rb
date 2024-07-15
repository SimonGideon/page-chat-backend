class DiscussionSerializer
  include JSONAPI::Serializer
  attributes :id, :book_id, :user_id, :comments, :created_at

  belongs_to :book, serializer: BookSerializer
  belongs_to :user, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer

  attribute :comments do |discussion|
    discussion.comments.map do |comment|
      CommentSerializer.new(comment).as_json
    end
  end
end
