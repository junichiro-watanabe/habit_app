Rails.application.routes.draw do
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get '/login_guest', to: 'sessions#create_guest'
  resources :users
  get '/users/:id/edit_image/', to:'users#edit_image'
end
