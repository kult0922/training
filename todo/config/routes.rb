Rails.application.routes.draw do
  resources :projects do
    resources :tasks do
      get :search, on: :collection
    end
  end
  root to: 'projects#index'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  unless Rails.env.development?
    get '*path', to: 'application#render_404'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
