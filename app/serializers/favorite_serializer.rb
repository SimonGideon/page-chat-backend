class FavoriteSerializer
  include JSONAPI::Serializer
  attributes :id, :book

  # belongs_to :book, serializer: BookSerializer
end
