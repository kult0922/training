Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'tasks#index'

  resources :tasks

  # for error (un exist URL)
  get '*anything' => 'errors#routing_error'
end
