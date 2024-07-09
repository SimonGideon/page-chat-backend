class CommentsController < ApplicationController
  def create
    discussion = Discussion.find_by(id: params[:discussion_id])
    user = User.find_by(id: params[:user_id])  # Assuming you have user_id in the params or can retrieve it
    comment = Comment.new(discussion: discussion, user: user)

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
    params.require(:comment).permit(:body, :discussion_id, :user_id)
  end
end
