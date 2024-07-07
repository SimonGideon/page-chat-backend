class AuthorsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: Author.all
  end

  def show
    render json: Author.find(params[:id])
  end

  def create
    author = Author.new(author_params)
    if author.save
      render json: author, status: :created
    else
      render json: author.errors, status: :unprocessable_entity
    end
  end

  def update
    author = Author.find(params[:id])
    if author.update(author_params)
      render json: author
    else
      render json: author.errors, status: :unprocessable_entity
    end
  end

  def destroy
    author = Author.find(params[:id])
    author.destroy
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name)
  end
end
