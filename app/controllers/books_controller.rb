class BooksController < ApplicationController
  respond_to :json

  #   get all books
  def index
    @books = Book.all
    render json: {
             status: { code: 200, message: "Successfully fetched books." },
             data: BookSerializer.new(@books).serializable_hash[:data].map { |book| book[:attributes] },

           }, status: :ok
  end

  #   get a specific book
  def show
    @book = Book.find(params[:id])
    render json: {
             status: { code: 200, message: "Successfully fetched book." },
             data: BookSerializer.new(@book).serializable_hash[:data][:attributes],
           }, status: :ok
  end

  #   post a book
  def create
    @book = Book.new(book_params)
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

  # patch/put a book
  def update
    @book = Book.find(params[:id])
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

  #   delete a book
  def destroy
    @book = Book.find(params[:id])
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
      :title, :description, :publication_year, :language,
      :publisher, :page_count, :isbn, :featured, :pdf, :cover_image
    )
  end
end
