Rails.application.routes.draw do
  root :to => 'tasks#index'
  
  resources :tasks
  resources :maintenance_schedules
  resources :users
  resources :labels

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
end
