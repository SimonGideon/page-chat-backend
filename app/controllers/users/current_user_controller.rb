module Users
  class CurrentUserController < ApplicationController
    include JwtAuthenticatable
    
    before_action :authenticate_user!

    def index
      render json: {
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
        status: :ok
      }
    end
  end
end
