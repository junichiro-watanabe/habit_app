Rails.application.routes.draw do
  get 'group/new'
  get 'group/edit'
  root 'static_pages#home'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get '/login_guest', to: 'sessions#create_guest'
  resources :users
  get '/users/:id/edit_image/', to: 'users#edit_image'
  get '/create_group', to: 'groups#new'
  resources :groups
  get '/groups/:id/edit_image/', to: 'groups#edit_image'
end
