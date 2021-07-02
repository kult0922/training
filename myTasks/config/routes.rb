Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'
  get "/search" => 'tasks#search'
  # search_path to: 'tasks#search'
  resources :tasks
end
