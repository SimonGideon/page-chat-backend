class FavoritesController < ApplicationController
  include JwtAuthenticatable
  
  before_action :authenticate_user!

  def index
    books = Book.joins(:favorites).where(favorites: { user_id: current_user.id })
    render json: {
      status: { code: 200, message: "Successfully fetched favorites." },
      data: BookSerializer.new(books).serializable_hash[:data].map { |book| book[:attributes] },
    }
  end

  def show
    user = User.includes(:favorites).find(params[:id])
    favorites = user.favorites

    render json: {
      status: { code: 200, message: "Successfully fetched favorites." },
      data: FavoriteSerializer.new(favorites).serializable_hash[:data].map { |fav| fav[:attributes] },
    }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render json: {
      status: { code: 404, message: "User not found." },
      errors: e.message,
    }, status: :not_found
  end

  def create
    favorite = Favorite.new(favorite_params)
    if favorite.save
      render json: {
        status: { code: 200, message: "Successfully created favorite." },
        data: FavoriteSerializer.new(favorite).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: favorite.errors, status: :unprocessable_entity
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
  end

  private

  def favorite_params
    params.require(:favorite).permit(:user_id, :book_id)
  end
end
