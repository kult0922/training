Rails.application.routes.draw do
  get 'labels/index'
  get 'labels/new'
  get 'labels/edit'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  scope '/admin' do
    resources :users, except: [:show]
    get '/users/:id/tasks_list', to: 'tasks#list'
  end

  resources :labels, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :tasks
  root 'tasks#index'
  unless Rails.env.development?
    get '*path', to: 'application#render404'
  end
end
