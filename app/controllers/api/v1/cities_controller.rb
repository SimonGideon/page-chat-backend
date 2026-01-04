module Api
  module V1
    class CitiesController < ApplicationController
      def index
        cities = if params[:country_id].present? || params[:country_code].present?
                   country_code = params[:country_code] || params[:country_id]
                   City.by_country(country_code).ordered
                 else
                   City.ordered
                 end
        render json: CitySerializer.new(cities, { params: { include_country: true } }).serializable_hash
      end

      def show
        city = City.find(params[:id])
        render json: CitySerializer.new(city, { params: { include_country: true } }).serializable_hash
      end
    end
  end
end

