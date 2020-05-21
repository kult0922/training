module TasksHelper
  def tasks_sort(column_name, val, search_title, search_status)
    if request.fullpath.include?('desc')
      link_to(column_name, sort: val, title: search_title, status: search_status)
    else
      link_to(column_name, sort: "#{val} desc", title: search_title, status: search_status)
    end
  end
end
