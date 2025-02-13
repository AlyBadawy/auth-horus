Rails.application.routes.draw do
  scope :admin do
    resources :roles
    resources :users
  end

  scope :identity do
    get "/", to: "sessions#index", as: "my_sessions"
    get "/:id", to: "sessions#show", as: "my_session"
    post "/sign_in", to: "sessions#sign_in", as: "sign_in"
    put "/refresh", to: "sessions#refresh", as: "refresh"
    delete "/sign_out", to: "sessions#sign_out", as: "sign_out"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
