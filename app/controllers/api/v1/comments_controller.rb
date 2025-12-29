module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_user!
      
      def index
        discussion = Discussion.find(params[:discussion_id])
        page = params[:page] || 1
        per_page = params[:per_page] || 10
        
        offset = (page.to_i - 1) * per_page.to_i
        # Only fetch top-level comments
        comments_query = discussion.comments.where(parent_id: nil)
        total_count = comments_query.count
        comments = comments_query.includes(:user, :comment_likes, replies: [:user, :comment_likes]).order(created_at: :desc).limit(per_page).offset(offset)
        
        serialized_comments = CommentSerializer.new(comments, { params: { current_user: current_user } }).serializable_hash[:data].map { |d| d[:attributes] }
        
        render json: {
          data: serialized_comments,
          meta: { total_count: total_count }
        }
      end

      def like
        comment = Comment.find(params[:id])
        like = comment.comment_likes.find_or_create_by(user: current_user)
        render json: { message: "Comment liked successfully", likes_count: comment.reload.likes_count }, status: :ok
      end

      def unlike
        comment = Comment.find(params[:id])
        like = comment.comment_likes.find_by(user: current_user)
        like&.destroy
        render json: { message: "Comment unliked successfully", likes_count: comment.reload.likes_count }, status: :ok
      end

      def create
        discussion = Discussion.find_by(id: params[:discussion_id])
        user = current_user || User.find_by(id: params[:user_id])
        comment = Comment.new(comment_params)
        comment.discussion = discussion
        comment.user = user

        if comment.save
          render json: { status: { code: 201, message: "Comment created successfully." }, data: CommentSerializer.new(comment, { params: { current_user: current_user } }).serializable_hash[:data][:attributes] }, status: :created
        else
          render json: { status: { code: 422, message: "Unable to create comment.", errors: comment.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def update
        comment = Comment.find(params[:id])
        if comment.update(comment_params)
          render json: comment
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end

      def destroy
        comment = Comment.find(params[:id])
        comment.destroy
      end

      private

      def comment_params
        params.require(:comment).permit(:body, :parent_id)
      end
    end
  end
end

