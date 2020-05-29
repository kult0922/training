Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  scope '/admin' do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
    get '/users/:id/tasks_list', to: 'tasks#list'
  end

  resources :tasks
  root 'tasks#index'
  unless Rails.env.development?
    get '*path', to: 'application#render404'
  end
end
