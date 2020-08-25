Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/login_failed', to: 'sessions#fail'

  resources :projects do
    resources :tasks
  end
  root to: 'sessions#new'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  unless Rails.env.development?
    get '*path', to: 'application#render_404'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
