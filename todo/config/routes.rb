Rails.application.routes.draw do
  resources :projects do
    resources :tasks
  end
  root to: 'projects#index'

  unless Rails.env.development?
    get '*path', to: 'application#render_404'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
