Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root to: 'tasks#index'
  resources :tasks

  get '*path', to: 'application#routing_error'
end
