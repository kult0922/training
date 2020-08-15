Rails.application.routes.draw do
  get  '/' => 'tasks#index', as: 'top'
  get  '/tasks/show'   => 'tasks#show'
  get  '/tasks/create' => 'tasks#create'
  post '/tasks/create' => 'tasks#new'
  get  '/tasks/edit'   => 'tasks#edit'
  patch '/tasks/edit'   => 'tasks#update'
  get  '/tasks/delete' => 'tasks#delete'
end
