# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  get 'login', to: 'sessions#index'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :tasks

  namespace :admin do
    resources :users
  end

  unless Rails.env.development?
    get '*path', to: 'application#routing_error'
  end
end
