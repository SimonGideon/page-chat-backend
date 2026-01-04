module Api
  module V1
    class CountriesController < ApplicationController
      def index
        countries = Country.ordered
        render json: CountrySerializer.new(countries).serializable_hash
      end

      def show
        country = Country.find(params[:id])
        render json: CountrySerializer.new(country, { params: { include_cities: true } }).serializable_hash
      end
    end
  end
end

