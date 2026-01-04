class CitySerializer
  include JSONAPI::Serializer

  attributes :id, :name, :state_province, :latitude, :longitude, :population

  belongs_to :country, 
             serializer: CountrySerializer,
             id_method_name: :country_code,
             if: proc { |_record, params| params&.dig(:include_country) }
end

