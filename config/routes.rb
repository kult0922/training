Rails.application.routes.draw do
  # トップ
  root 'tasks#index'

  match '/search' => 'tasks#search', via: [:get, :post]

  # タスク登録画面
  get 'tasks/newtask' => "tasks#newtask"

  # タスク登録処理
  post 'tasks/createtask' => "tasks#createtask"

  # タスク詳細画面
  get 'tasks/taskdetail/:id' => 'tasks#taskdetail', :as => :tasks_taskdetail

  # タスク編集画面
  get 'tasks/taskupdate/:id' => 'tasks#taskupdate', :as => :tasks_taskupdate

  # タスク更新処理
  patch 'tasks/taskupdateprocess' => "tasks#taskupdateprocess"

  delete 'tasks/taskdelete/:id' => "tasks#taskdelete", :as => :tasks_taskdelete
end
