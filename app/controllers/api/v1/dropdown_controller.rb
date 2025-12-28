module Api
  module V1
    class DropdownController < ApplicationController
      def get_drop_down_list
        page = params[:page]
        filters = params[:filters] || {}

        case page
        when "countries"
          countries = Country.ordered
          data = countries.map do |country|
            {
              text: country.name,
              value: country.code,
            }
          end
          render json: { success: true, data: data }
        when "languages"
            languages = Language.order(:name)
            data = languages.map do |language|
              {
                text: language.name,
                value: language.code,
              }
            end
            render json: { success: true, data: data }
        when "cities"
          country_code = filters["country_code"] || filters[:country_code]
          if country_code.present?
            cities = City.where(country_code: country_code).ordered
            data = cities.map do |city|
              {
                text: city.state_province.present? ? "#{city.name}, #{city.state_province}" : city.name,
                value: city.id,
              }
            end
            render json: { success: true, data: data }
          else
            render json: { success: true, data: [] }
          end
        else
          render json: { success: false, data: [], message: "Unknown page: #{page}" }, status: :bad_request
        end
      end
    end
  end
end

