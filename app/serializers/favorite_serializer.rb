class FavoriteSerializer
  include JSONAPI::Serializer
  attributes :id, :user, :book

  belongs_to :book, serializer: BookSerializer
end
