module TasksHelper
  def create_sort_link(link_name, search_title, search_status, sort)
    sort = sort.split(' ')
    if link_name == sort.first
      if sort.second.nil?
        link_to("#{Task.human_attribute_name(link_name)}▲", sort: "#{link_name} desc", title: search_title, status: search_status)
      else
        link_to("#{Task.human_attribute_name(link_name)}▼", sort: link_name, title: search_title, status: search_status)
      end
    else
      link_to(Task.human_attribute_name(link_name), sort: "#{link_name} desc", title: search_title, status: search_status)
    end
  end
end
