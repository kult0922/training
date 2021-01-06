# frozen_string_literal: true

Rails.application.routes.draw do
  root 'sessions#index'
  resources :tasks

  resources :sessions

  get '*path', to: 'application#routing_error'
end
