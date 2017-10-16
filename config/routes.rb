Rails.application.routes.draw do
  get 'sessions/new'

  root 'sessions#new'
  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
