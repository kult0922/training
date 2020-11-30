Rails.application.routes.draw do

  # トップ
  root 'tasks#index'

  get '/:sortno', :to => 'tasks#index'

  # タスク登録画面
  get 'tasks/newtask' => "tasks#newtask"

  # タスク登録処理
  post 'tasks/createtask' => "tasks#createtask"

  # タスク詳細画面
  get 'tasks/taskdetail/:id', :to => 'tasks#taskdetail',:as => :tasks_taskdetail

  # タスク編集画面
  get 'tasks/taskupdate/:id', :to => 'tasks#taskupdate',:as => :tasks_taskupdate

  # タスク更新処理
  patch 'tasks/taskupdateprocess' => "tasks#taskupdateprocess"

  delete 'tasks/taskdelete/:id', :to => "tasks#taskdelete",:as => :tasks_taskdelete

end
