Trestle.resource(:cities) do
  menu do
    item :cities, icon: "fa fa-building", group: :settings
  end

  table do
    column :name
    column :country, ->(city) { city.country.name }
    column :state_province
    column :population
    column :latitude
    column :longitude
    column :created_at, align: :center
    actions
  end

  form do |_city|
    collection_select :country_code, Country.ordered, :code, :name, { prompt: "Select a country" }
    text_field :name
    text_field :state_province, placeholder: "State or Province (optional)"
    number_field :latitude, step: :any, placeholder: "e.g., 40.7128"
    number_field :longitude, step: :any, placeholder: "e.g., -74.0060"
    number_field :population, placeholder: "Population count (optional)"
  end

  params do |params|
    params.require(:city).permit(:country_code, :name, :state_province, :latitude, :longitude, :population)
  end
end

