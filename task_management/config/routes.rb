Rails.application.routes.draw do
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  root 'tasks#index'
  resources :tasks
  get '*path', to: 'application#render404'
end
