json.extract! task, :id, :title, :detail, :status, :priority, :end_date, :deleted_at, :created_at, :updated_at
json.url task_url(task, format: :json)
