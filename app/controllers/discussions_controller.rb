class DiscussionsController < ApplicationController
  def index
    book = Book.find(params[:book_id])
    discussions = book.discussions.includes(:comments)
    render json: discussions
  end

  def create
    book = Book.find_by(id: params[:book_id])
    user = User.find_by(id: params[:user_id])  # Assuming you have user_id in the params or can retrieve it
    discussion = Discussion.new(book: book, user: user)

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
    params.require(:discussion).permit(:title, :body, :book_id, :user_id, :comments_id)
  end
end
