Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/" => "tasks#list"
  get "/tasks/:id" => "tasks#detail"
  get "/tasks" => "tasks#new"
  post "/tasks" => "tasks#create"
  patch "/tasks/:id" => "tasks#update"
  delete "/tasks/:id" => "tasks#destroy"
  get "/edit/:id" => "tasks#edit"
end
