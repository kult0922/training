Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :tasks
  root 'tasks#index'
  unless Rails.env.development?
    get '*path', to: 'application#render404'
  end
end
