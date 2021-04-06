Rails.application.routes.draw do
  get 'task/new'
  get 'task/show'
  post 'task/create'
  get 'task/edit'
  patch 'task/update'
  delete 'task/destroy'
  get 'task/list'
  get 'maintenance_schedules/create'
  get 'maintenance_schedules/update'
  get 'maintenance_schedules/destroy'
  get 'user/create'
  get 'user/update'
  get 'user/destroy'
  get 'label/create'
  get 'label/update'
  get 'label/destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
