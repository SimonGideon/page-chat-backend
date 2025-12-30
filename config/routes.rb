Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users, path: "", path_names: {
                           sign_in: "login",
                           sign_out: "logout",
                           registration: "signup",
                           confirmation: "activate-account",
                         },
                         controllers: {
                           sessions: "api/v1/users/sessions",
                           registrations: "api/v1/users/registrations",
                           confirmations: "api/v1/users/confirmations",
                         }

      get "/current_user", to: "users/current_user#index"
      patch "/users/change_password", to: "users/users#change_password"

      resources :users, only: %i[index update], controller: "users/users" do
        resources :favorites, only: [:index]
      end

      post "/password/reset", to: "users/passwords#create"
      get "/password/reset", to: "users/passwords#show"
      put "/password/reset", to: "users/passwords#update"

      # Use Devise's confirmation routes
      get "/activate-account", to: "users/confirmations#show"

      resources :books, only: %i[index show] do
        member do
           get :preview
        end
        resource :reading_position, only: [:update], controller: 'reading_positions'
        resources :discussions do
          resources :comments do
            member do
              post :like
              delete :like, action: :unlike
            end
          end
        end
        collection do
          get :recommended
          get :featured
        end
      end

      resources :authors, only: %i[index show]
      get "/engagements", to: "discussions#engagements"
      resources :favorites, only: [:create, :show, :index, :destroy]
      resources :categories
      resources :countries, only: [:index, :show] do
        resources :cities, only: [:index], controller: "cities"
      end
      resources :cities, only: [:index, :show]
      post "/dropdown/get-drop-down-list", to: "dropdown#get_drop_down_list"
    end
  end
end
