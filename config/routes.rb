# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :tasks do
    resources :completions, only: [:index], module: 'tasks'
    resources :starts, only: [:index], module: 'tasks'
  end
  resources :filters, only: [:index], module: 'tasks'

  root 'tasks#index'
end
