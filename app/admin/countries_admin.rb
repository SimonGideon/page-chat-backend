Trestle.resource(:countries) do
  menu do
    item :countries, icon: "fa fa-globe", group: :settings
  end

  table do
    column :name
    column :code
    column :iso3
    column :capital
    column :currency_code
    column :phone_code
    column :created_at, align: :center
    actions
  end

  form do |_country|
    text_field :name
    text_field :code, placeholder: "ISO 3166-1 alpha-2 (e.g., US, GB)"
    text_field :iso3, placeholder: "ISO 3166-1 alpha-3 (e.g., USA, GBR)"
    text_field :numeric_code, placeholder: "ISO 3166-1 numeric (e.g., 840, 826)"
    text_field :capital
    text_field :currency_code, placeholder: "ISO 4217 (e.g., USD, GBP)"
    text_field :phone_code, placeholder: "International dialing code (e.g., +1, +44)"
  end

  params do |params|
    params.require(:country).permit(:name, :code, :iso3, :numeric_code, :capital, :currency_code, :phone_code)
  end
end

