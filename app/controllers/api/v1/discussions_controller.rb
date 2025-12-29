module Api
  module V1
    class DiscussionsController < ApplicationController
      before_action :authenticate_user!
      
      def engagements
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        
        offset = (page.to_i - 1) * per_page.to_i
        discussions = current_user.discussions.includes(:book).order(created_at: :desc).limit(per_page).offset(offset)
        total_count = current_user.discussions.count

        render json: {
          status: { code: 200, message: "Successfully fetched engagements." },
          data: DiscussionSerializer.new(discussions).serializable_hash[:data].map { |d| d[:attributes] },
          meta: { total_count: total_count }
        }
      end

      def index
        book = Book.find(params[:book_id])
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        
        offset = (page.to_i - 1) * per_page.to_i
        discussions = book.discussions.includes(:user).order(created_at: :desc).limit(per_page).offset(offset)
        total_count = book.discussions.count

        render json: {
          data: DiscussionSerializer.new(discussions).serializable_hash[:data].map { |d| d[:attributes] },
          meta: { total_count: total_count }
        }
      end

      def create
        book = Book.find_by(id: params[:book_id])
        user = current_user || User.find_by(id: params[:user_id])
        discussion = Discussion.new(discussion_params)
        discussion.book = book
        discussion.user = user

        if discussion.save
          render json: { status: { code: 201, message: "Discussion created successfully." }, data: discussion }, status: :created
        else
          render json: { status: { code: 422, message: "Unable to create discussion.", errors: discussion.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def update
        discussion = Discussion.find(params[:id])
        if discussion.update(discussion_params)
          render json: discussion
        else
          render json: discussion.errors, status: :unprocessable_entity
        end
      end

      def destroy
        discussion = Discussion.find(params[:id])
        discussion.destroy
      end

      private

      def discussion_params
        params.require(:discussion).permit(:title, :body)
      end
    end
  end
end

