Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks do
    collection do
      get :search
    end
  end
  resource :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    root to: 'admin/users#index'
    resource :sessions, only: [:new, :create, :destroy]
    resources :users do
      resources :tasks, only: [:index]
    end
  end

  # どのルーティングにもマッチしなかったら、404ページにリダイレクト
  get '*path', controller: 'application', action: 'rescue404'
end
