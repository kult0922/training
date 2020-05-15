module TasksHelper
  def tasks_sort(column_name, val, title, status)
    request.fullpath.include?('desc') ? link_to(column_name, sort: val, title: title, status: status) : link_to(column_name, sort: "#{val} desc", title: title, status: status)
  end
end
