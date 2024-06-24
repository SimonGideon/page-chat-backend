module Users
  class UsersController < ApplicationController
    respond_to :json

    def index
      @users = User.all
      render json: {
               status: { code: 200, message: "Successfully fetched users." },
               data: UserSerializer.new(@users).serializable_hash[:data].map { |user| user[:attributes] },
             }, status: :ok
    end
  end
end
