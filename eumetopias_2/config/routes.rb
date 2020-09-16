Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'task#index'
  resources :task
  get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
