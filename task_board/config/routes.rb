Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'tasks#index'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: %I[new create]
  resources :tasks

  namespace :admin do
    resources :users do
      get 'edit_password', on: :member
    end
  end

  get '*path', to: 'application#routing_error'
end
