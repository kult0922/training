module TasksHelper
  def create_sort_link(column_name, val, search_title, search_status, sort)
    sort = sort.split(' ')
    if val == sort[0]
      if request.fullpath.include?('desc')
        link_to("#{column_name}▲", sort: val, title: search_title, status: search_status)
      else
        link_to("#{column_name}▼", sort: "#{val} desc", title: search_title, status: search_status)
      end
    else
      link_to(column_name, sort: val, title: search_title, status: search_status)
    end
  end
end
