Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: [:create]

  post '/auth/login', to: "auth#login"
  get '/bio', to: "users#bio"
end
