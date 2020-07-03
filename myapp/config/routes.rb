Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks do
    get :search, on: :collection
  end
  root to: 'tasks#index'

  resources :users, only: [:new, :create]
  namespace :admin do
    resources :users
  end

  resources :labels

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get '*path', to: 'application#rescue404' 
end
