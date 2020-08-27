Rails.application.routes.draw do
  # タスク画面
  root 'tasks#index'
  resources :tasks

  # ソート機能
  get 'search' => 'tasks#search'

  # エラー画面
  get '*anything' => 'errors#routing_error'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
