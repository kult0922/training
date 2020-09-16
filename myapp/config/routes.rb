# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  root 'users#index'

  resources :users do
    resources :tasks
  end

  get '*path', to: 'application#error_404'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
