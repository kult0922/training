Rails.application.routes.draw do
  root 'task#index'
  resources :task
  get '*path', to: 'application#render_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
