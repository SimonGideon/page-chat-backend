Rails.application.routes.draw do
  get "/current_user", to: "users/current_user#index"
  devise_for :users, path: "", path_names: {
                       sign_in: "login",
                       sign_out: "logout",
                       registration: "signup",
                     },
                     controllers: {
                       sessions: "users/sessions",
                       registrations: "users/registrations",
                     }
  resources :users, only: %i[index], controller: "users/users" do
    resources :favorites, only: [:index]
  end
  resources :books do
    resources :discussions do
      resources :comments
    end
  end
  resources :authors
  resources :favorites, only: [:create, :show, :index, :destroy]
  resources :categories
end
