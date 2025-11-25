Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, path: "", path_names: {
                           sign_in: "login",
                           sign_out: "logout",
                           registration: "signup",
                         },
                         controllers: {
                           sessions: "api/v1/users/sessions",
                           registrations: "api/v1/users/registrations",
                         }

      get "/current_user", to: "users/current_user#index"

      resources :users, only: %i[index], controller: "users/users" do
        resources :favorites, only: [:index]
      end

      resources :books do
        resources :discussions do
          resources :comments
        end
        collection do
          get :recommended
          get :featured
        end
      end

      resources :authors
      resources :favorites, only: [:create, :show, :index, :destroy]
      resources :categories
    end
  end
end
