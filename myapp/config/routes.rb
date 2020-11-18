Rails.application.routes.draw do
  root to: 'tasks#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/admin', to: 'admin#index'

  resources :tasks
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '*path' => 'application#render_404'
end
