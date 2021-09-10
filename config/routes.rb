Rails.application.routes.draw do
  resources :users
  resources :todos
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

 # get '/user/signup' => 'users#new'
 # post '/user/signup' => 'users#create'
  get '/user/login' => 'users#login'
  post '/user/login' => 'users#signin'
  get '/users/:id' => 'users#profile', as: 'user_profile'
  get '/logout' => 'application#logout'

  resources :users, only: [:show] do 
    resources :todos, only: [:index, :show, :new, :create, :update, :edit, :destroy]
  end 
end
