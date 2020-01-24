Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resources :tasks
    resources :sessions

    namespace :admin do
      resources :users
    end

    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'
    get 'under_maintenance', to: 'maintenance#under_maintenance'

    match '/404', :to => 'errors#not_found', :via => :all
    match '/500', :to => 'errors#internal_server_error', :via => :all

    root to: 'tasks#index'
  end
end
