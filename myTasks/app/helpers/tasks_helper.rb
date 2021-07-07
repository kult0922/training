module TasksHelper
  def status_back(task)
    return 'background: #dd4A00;' if task.status == 'todo'
    return 'background: #00bcd4;' if task.status == 'in_progress'
    return 'background: #00dd7a;' if task.status == 'done'
  end
end
