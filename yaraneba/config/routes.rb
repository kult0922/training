Rails.application.routes.draw do
  get 'top' => 'top#index'

  get 'users' => 'users#new'
  post 'users' => 'users#create'

  get 'login' => 'login#new'
  post 'login' => 'login#create'
  delete 'login' => 'login#destroy'

  root to: 'top#index'
  resources :tasks, path: '/tasks'
end
