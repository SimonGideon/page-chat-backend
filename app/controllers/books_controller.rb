class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_book, only: %i[show update destroy]
  respond_to :json

  # Get all books
  def index
    @books = Book.all
    render json: {
      status: { code: 200, message: "Successfully fetched books." },
      data: BookSerializer.new(@books).serializable_hash[:data].map { |book| book[:attributes] },
    }, status: :ok
  end

  # Get a specific book
  def show
    render json: {
      status: { code: 200 },
      data: BookSerializer.new(@book).serializable_hash[:data][:attributes],
    }, status: :ok
  end

  # Post a book
  def create
    @book = Book.new(book_params)

    # Associate attachments with the book instance
    @book.pdf.attach(params[:boo][:pdf]) if params[:boo][:pdf].present?
    @book.cover_image.attach(params[:boo][:cover_image]) if params[:boo][:cover_image].present?

    if @book.save
      render json: {
        status: { code: 200, message: "Successfully created book." },
        data: BookSerializer.new(@book).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Book could not be created." },
        errors: @book.errors.full_messages,
      }, status: :unprocessable_entity
    end
  end

  # Patch/put a book
  def update
    if @book.update(book_params)
      render json: {
        status: { code: 200, message: "Successfully updated book." },
        data: BookSerializer.new(@book).serializable_hash[:data][:attributes],
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Book could not be updated." },
        errors: @book.errors.full_messages,
      }, status: :unprocessable_entity
    end
  end

  # Delete a book
  def destroy
    if @book.destroy
      render json: {
        status: { code: 200, message: "Successfully deleted book." },
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Book could not be deleted." },
        errors: @book.errors.full_messages,
      }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      :title, :description, :language,
      :publisher, :isbn, :page_count,
      boo: [:pdf, :cover_image],
    ).with_defaults(published_at: Time.now)
  end
end
