Rails.application.routes.draw do
  resources :projects
  root to: 'projects#index'

  resources :tasks

  get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
