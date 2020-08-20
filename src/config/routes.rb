Rails.application.routes.draw do
  get '/sign_up', to: 'users#new'
  root 'static_pages#home'
  resources :users
end
