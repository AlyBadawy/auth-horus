Rails.application.routes.draw do
  scope :admin do
    resources :roles
    resources :users
  end

  mount Flipper::Api.app(Flipper) => "/admin/flipper"

  resource :session, as: "current_session" # create (sign_in), show (current_session), update (refresh), destroy(sign_out)
  resources :sessions, only: [:index, :show, :destroy] # list sessions, show specific session, revoke specific session

  resources :passwords, param: :token, only: [:create, :update]

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
