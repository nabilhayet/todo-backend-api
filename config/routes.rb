Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post 'user/login' => 'users#login'
  delete 'user/logout' => 'users#destroy'
  


  resources :users, only: [:show] do 
    resources :todos, only: [:index, :show, :new, :create, :update, :edit, :destroy]
  end 

  resources :users, only: [:index, :show, :create]
  resources :todos
end
