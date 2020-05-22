Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks

  # どのルーティングにもマッチしなかったら、404ページにリダイレクト
  get '*path', controller: 'application', action: 'rescue404'
end
