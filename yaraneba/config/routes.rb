Rails.application.routes.draw do
  get 'users' => 'users#new'
  post 'users' => 'users#create'

  get 'login' => 'login#new'
  post 'login' => 'login#create'
  delete 'login' => 'login#destroy'

  root to: 'tasks#index'
  resources :tasks, path: '/'
end
