# frozen_string_literal: true

Rails.application.routes.draw do
  root 'users#index'
  resources :tasks

  resources :users do
    collection do
      post 'login'
    end
  end

  get '*path', to: 'application#routing_error'
end
