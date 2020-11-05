Rails.application.routes.draw do
  root 'static_pages#home'
  get 'group/new'
  get 'group/edit'
  get '/signup', to: 'users#new'
  get '/login', to: 'static_pages#home'
  post '/login', to: 'sessions#create'
  delete '/login', to: 'sessions#destroy'
  get '/login_guest', to: 'sessions#create_guest'
  resources :users
  resources :users do
    member do
      get :edit_image, :delete, :owning, :belonging, :following, :followers, :like_feeds
      patch :not_achieved, :encouraged
    end
  end
  get '/create_group', to: 'groups#new'
  resources :groups
  resources :groups do
    member do
      get :edit_image, :delete, :member
    end
  end
  resources :belongs, only: [:update, :destroy]
  resources :achievements, only: [:update]
  resources :achievements do
    member do
      post :encourage
    end
  end
  resources :microposts, only: [:destroy]
  resources :relationships, only: [:update, :destroy]
  resources :messages, only: [:show, :update]
  resources :likes, only: [:show, :update, :destroy]
  resources :contacts, only: [:index, :show, :create, :destroy]
  resources :notifications, only: [:update]
end
