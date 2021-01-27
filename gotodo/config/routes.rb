Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, :tasks
  namespace :admin do
    resources :users, only: [:index] do
      member do
        get '/tasks', to: 'tasks#index'
      end
    end
  end
  get '/profile', to: 'users#show'
  post '/profile', to: 'users#create'
  get '/profile/edit', to: 'users#edit'
end
