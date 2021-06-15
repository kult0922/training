Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks
  
  get '*path', controller: :application, action: :render_404
  get '*path', controller: :application, action: :render_500
end
