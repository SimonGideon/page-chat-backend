class BoooksController < ApplicationController
  respond_to :json

  def index
    @boooks = Boook.all
    render json: {
             status: { code: 200, message: "Successfully fetched boooks." },
             data: BoookSerializer.new(@boooks).serializable_hash[:data].map { |boook| boook[:attributes] },
           }, status: :ok
  end
end
