module Api
  module V1
    class FavoritesController < ApplicationController
      include JwtAuthenticatable
      
      before_action :authenticate_user!

      def index
        books = Book.joins(:favorites)
                    .where(favorites: { user_id: current_user.id })
                    .includes(:author, :category)
                    .with_attached_cover_image
                    .with_attached_pdf
        render json: {
          status: { code: 200, message: "Successfully fetched favorites." },
          data: BookSerializer.new(books, { params: { current_user: current_user } }).serializable_hash[:data].map { |book| book[:attributes] },
        }
      end

      def show
        user = User.find(params[:id])
        favorites = user.favorites.includes(book: [:author, :category, :cover_image_attachment, :pdf_attachment])

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
        favorite.user = current_user
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
  end
end

