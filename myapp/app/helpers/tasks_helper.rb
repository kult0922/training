module TasksHelper
  def create_sort_link(val, search_title, search_status, sort, sort_array)
    desc_or_not = sort_array.select { |a| a.include?(val) }
    sort = sort.split(' ')
    if desc_or_not.first == sort.first
      if sort.second.nil?
        link_to("#{Task.human_attribute_name(val)}▲", sort: desc_or_not.second, title: search_title, status: search_status)
      else
        link_to("#{Task.human_attribute_name(val)}▼", sort: desc_or_not.first, title: search_title, status: search_status)
      end
    else
      link_to(Task.human_attribute_name(val), sort: desc_or_not.second, title: search_title, status: search_status)
    end
  end
end
