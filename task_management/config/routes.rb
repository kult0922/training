Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  namespace :admin do
    resources :users
  end
  root 'tasks#index'
  resources :tasks
  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]
  get '*path', to: 'application#render404'
end
