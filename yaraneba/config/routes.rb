Rails.application.routes.draw do
  get 'top' => 'top#index'

  get 'login' => 'login#new'
  post 'login' => 'login#create'
  delete 'login' => 'login#destroy'

  root to: 'top#index'
  resources :tasks, path: '/tasks'
  resources :users, path: '/users'

  get 'admin/users' => 'admin#user'
  get 'admin/new' => 'admin#new'
  get 'admin/tasks' => 'admin#task'
  get 'admin/users/new' => 'admin#user_new'
  post 'admin/users' => 'admin#user_create'

  resources :labels, path: '/labels', except: [:new, :show, :create]
end
