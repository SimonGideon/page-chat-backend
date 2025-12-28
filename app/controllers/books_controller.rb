class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[ recommended featured ]
  before_action :authenticate_user_optional, only: %i[ recommended featured ]
  before_action :set_book, only: %i[show update destroy]

  # GET /books
  def index
    @books = Book.includes(:author, :category).with_attached_pdf.with_attached_cover_image
    @books = @books.where(language: params[:language]) if params[:language].present?
    render json: serialized_books(@books), status: :ok
  end

  #get featured books
  def featured
    @books = Book.where(featured: true).includes(:author, :category).with_attached_pdf.with_attached_cover_image
    @books = @books.where(language: params[:language]) if params[:language].present?
    render json: serialized_books(@books), status: :ok
  end

  # get recommended books
  def recommended
    @books = Book.where(recommended: true).includes(:author, :category).with_attached_pdf.with_attached_cover_image
    @books = @books.where(language: params[:language]) if params[:language].present?
    render json: serialized_books(@books), status: :ok
  end

  # GET /books/:id
  def show
    render json: serialized_book(@book), status: :ok
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    # Associate attachments with the book instance
    @book.pdf.attach(params[:boo][:pdf]) if params[:boo][:pdf].present?
    @book.cover_image.attach(params[:boo][:cover_image]) if params[:boo][:cover_image].present?

    if @book.save
      render json: serialized_book(@book), status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      render json: serialized_book(@book), status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    if @book.destroy
      render json: { message: "Book successfully deleted." }, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(
      :title, :description, :language,
      :publisher, :isbn, :page_count, :author_id, :category_id, :recommended,
      boo: [:pdf, :cover_image],
    ).with_defaults(published_at: Time.now)
  end

  def serialized_book(book)
    {
      status: { code: 200 },
      data: BookSerializer.new(book, { params: { current_user: current_user } }).serializable_hash[:data][:attributes],
    }
  end

  def serialized_books(books)
    {
      status: { code: 200, message: "Successfully fetched books." },
      data: BookSerializer.new(books, { params: { current_user: current_user } }).serializable_hash[:data].map { |book| book[:attributes] },
    }
  end
end
