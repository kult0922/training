Rails.application.routes.draw do
  resources :projects
  root to: 'projects#index'

  resources :tasks

  unless Rails.env.development?
    get '*path', to: 'application#render_404'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
