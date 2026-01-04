class CartegorySerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description
end
