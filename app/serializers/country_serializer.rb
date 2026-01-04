class CountrySerializer
  include JSONAPI::Serializer

  attributes :id, :name, :code, :iso3, :capital, :currency_code, :phone_code

  has_many :cities, if: proc { |_record, params| params&.dig(:include_cities) }
end

