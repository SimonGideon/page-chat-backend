class BoooksController < ApplicationController
  respond_to :json

  #   get all books
  def index
    @boooks = Boook.all
    render json: {
             status: { code: 200, message: "Successfully fetched boooks." },
             data: BoookSerializer.new(@boooks).serializable_hash[:data].map { |boook| boook[:attributes] },

           }, status: :ok
  end

  #   get a specific book
  def show
    @boook = Boook.find(params[:id])
    render json: {
             status: { code: 200, message: "Successfully fetched boook." },
             data: BoookSerializer.new(@boook).serializable_hash[:data][:attributes],
           }, status: :ok
  end

  #   post a book
  def create
    @boook = Boook.new(boook_params)
    if @boook.save
      render json: {
               status: { code: 200, message: "Successfully created boook." },
               data: BoookSerializer.new(@boook).serializable_hash[:data][:attributes],
             }, status: :ok
    else
      render json: {
               status: { code: 422, message: "Boook could not be created." },
               errors: @boook.errors.full_messages,
             }, status: :unprocessable_entity
    end
  end

  # patch/put a book
  def update
    @boook = Boook.find(params[:id])
    if @boook.update(boook_params)
      render json: {
               status: { code: 200, message: "Successfully updated boook." },
               data: BoookSerializer.new(@boook).serializable_hash[:data][:attributes],
             }, status: :ok
    else
      render json: {
               status: { code: 422, message: "Boook could not be updated." },
               errors: @boook.errors.full_messages,
             }, status: :unprocessable_entity
    end
  end

  #   delete a book
  def destroy
    @boook = Boook.find(params[:id])
    if @boook.destroy
      render json: {
               status: { code: 200, message: "Successfully deleted boook." },
             }, status: :ok
    else
      render json: {
               status: { code: 422, message: "Boook could not be deleted." },
               errors: @boook.errors.full_messages,
             }, status: :unprocessable_entity
    end
  end

  private

  def set_boook
    @boook = Boook.find(params[:id])
  end

  def boook_params
    params.require(:boook).permit(:title, :author, :genre, :published)
  end
end
