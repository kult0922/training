# frozen_string_literal: true

Rails.application.routes.draw do
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'tasks#index'

  resources :tasks
  get '*path', to: 'application#error_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
