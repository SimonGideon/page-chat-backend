class FavoriteSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :book_id

  belongs_to :book, serializer: BookSerializer
end
