Rails.application.routes.draw do
  root 'tasks#index'
  get 'tasks/newtask' => "tasks#newtask"
  post 'tasks/createtask' => "tasks#createtask"
  # get 'tasks/taskdetail' => "tasks#taskdetail"
  get 'tasks/taskdetail/:id', :to => 'tasks#taskdetail'
end
