Rails.application.routes.draw do
  root 'tasks#index'
  get 'tasks/newtask' => "tasks#newtask"
  post 'tasks/createtask' => "tasks#createtask"
end
