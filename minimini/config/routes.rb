Rails.application.routes.draw do
  root :to => 'tasks#list'
  
  resources :tasks
  resources :maintenance_schedules
  resources :users
  resources :labels
end
