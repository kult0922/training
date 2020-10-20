Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  get '*path', to: 'application#routing_error'
end
