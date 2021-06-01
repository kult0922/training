# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: %i[new create]
  resources :sessions, only: %i[new create destroy]
  get 'logout', to: 'sessions#destroy', as: :logout
  resources :tasks do
    resources :completions, only: [:index], module: 'tasks'
    resources :starts, only: [:index], module: 'tasks'
  end
  root 'sessions#new'
end
