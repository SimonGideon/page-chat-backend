class DiscussionSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :body, :book_id, :user_id, :created_at

  belongs_to :book, serializer: BookSerializer
  belongs_to :user, serializer: UserSerializer

  attribute :book do |discussion|
    BookSerializer.new(discussion.book).serializable_hash[:data][:attributes]
  end

  attribute :user do |discussion|
    {
      id: discussion.user.id,
      first_name: discussion.user.first_name,
      last_name: discussion.user.last_name,
      avatar_url: discussion.user.avatar_url
    }
  end

  attribute :comments_count do |discussion|
    discussion.comments.count
  end

  attribute :recent_commenters do |discussion|
    discussion.comments.includes(:user).order(created_at: :desc).limit(10).map(&:user).uniq.take(5).map do |user|
      {
        id: user.id,
        first_name: user.first_name,
        avatar_url: user.avatar_url
      }
    end
  end
end
