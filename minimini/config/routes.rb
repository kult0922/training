Rails.application.routes.draw do
  root :to => 'tasks#list'
  # resources :tasks

  get 'tasks/new'
  get 'tasks/show'
  post 'tasks/create'
  get 'tasks/edit'
  patch 'tasks/update'
  delete 'tasks/destroy'
  get 'tasks/list'
  get 'maintenance_schedules/create'
  get 'maintenance_schedules/update'
  get 'maintenance_schedules/destroy'
  get 'users/create'
  get 'users/update'
  get 'users/destroy'
  get 'labels/create'
  get 'labels/update'
  get 'labels/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
