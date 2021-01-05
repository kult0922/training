# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#index'
  resources :tasks

  resources :sessions do
    collection do
      post 'login'
    end
  end

  get '*path', to: 'application#routing_error'
end
