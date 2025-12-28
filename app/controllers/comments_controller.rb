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
    comments = comments_query.includes(:user, replies: [:user]).order(created_at: :desc).limit(per_page).offset(offset)
    
    serialized_comments = CommentSerializer.new(comments).serializable_hash[:data].map { |d| d[:attributes] }
    
    render json: {
      data: serialized_comments,
      meta: { total_count: total_count }
    }
  end

  def create
    discussion = Discussion.find_by(id: params[:discussion_id])
    user = current_user || User.find_by(id: params[:user_id])
    comment = Comment.new(comment_params)
    comment.discussion = discussion
    comment.user = user

    if comment.save
      render json: { status: { code: 201, message: "Comment created successfully." }, data: comment }, status: :created
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
