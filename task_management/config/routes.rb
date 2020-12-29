# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks

  get '*path', to: 'application#routing_error'
end
