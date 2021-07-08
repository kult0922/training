module TasksHelper
  def status_label_class(task)
    return 'status-label-todo' if task.todo?
    return 'status-label-in-progress' if task.in_progress?
    return 'status-label-done' if task.done?
  end
end
