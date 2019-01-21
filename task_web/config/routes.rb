# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root 'tasks#index'
  resources :tasks
  get '*path', controller: 'application', action: 'error_404'
end
