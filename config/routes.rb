Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create]
  resources :invoices, except: :destroy
  
  get "/activate_token/:id" => "users#activate_token", as: 'activate_user_token'
  
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"

  root :to => "sessions#new"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
