Rails.application.routes.draw do
  resources :users
  resources :invoices
  
  get "/invoice_emails/:id" => "invoices#edit_emails", as: 'edit_emails'
  post "/invoice_emails/:id" => "invoices#save_emails", as: 'save_emails'
  get "/activate_token/:id" => "users#activate_token", as: 'activate_user_token'
  
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "login", to: "sessions#new"

  root :to => "sessions#new"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
