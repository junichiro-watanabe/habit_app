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
  resources :users do
    member do
      get :edit_image, :delete, :owning, :belonging
    end
  end
  get '/create_group', to: 'groups#new'
  resources :groups
  resources :groups do
    member do
      get :edit_image, :delete, :member
    end
  end
end
