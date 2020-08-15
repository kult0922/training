class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { maximum: 1000 }
  validates :status_code, presence: true
  validates :priority_code, presence: true
  validates :expire_date, presence: true, date: true

  scope :search, -> (params) do
    tasks = Task.where(deleted_flag: false)
    return tasks if params == nil

    if !params[:task_name].empty?
      params[:task_name] = "%" + params[:task_name] + "%"
      tasks = tasks.where("name like ? or description like ?", params[:task_name], params[:task_name])
    end

    if params[:status_code] != "-1"
      tasks = tasks.where("status_code = ?", params[:status_code])
    end

    if params[:register_user_id] != "-1"
      tasks = tasks.where("register_user_id = ?", params[:register_user_id])
    end
    
    return tasks
  end
end
