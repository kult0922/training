module TasksHelper
  def create_sort_link(val, search_title, search_status, sort, sort_array)
    desc_or_not = sort_array.select { |a| a.include?(val) }
    sort = sort.split(' ')
    target_column = sort.first
    order = sort.second
    if desc_or_not.first == target_column
      if order.nil?
        link_to("#{Task.human_attribute_name(val)}▲", sort: desc_or_not.second, title: search_title, status: search_status)
      else
        link_to("#{Task.human_attribute_name(val)}▼", sort: desc_or_not.first, title: search_title, status: search_status)
      end
    else
      link_to(Task.human_attribute_name(val), sort: desc_or_not.second, title: search_title, status: search_status)
    end
  end
end
