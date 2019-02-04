Rails.application.routes.draw do
  root 'users#index'
  resources :users, only: [ :new, :show, :create, :update, :destroy, :edit]
  get '/signin' => 'sessions#new'
  post '/signin' => 'sessions#create'
  get '/logout' => 'sessions#logout'
  resources :attractions, only: [ :index, :new, :show, :create, :update, :destroy, :edit]
end
