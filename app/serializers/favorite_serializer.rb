class FavoriteSerializer
  include JSONAPI::Serializer
  attributes :id
  
  attribute :book do |favorite|
    BookSerializer.new(favorite.book).serializable_hash[:data][:attributes]
  end
end
