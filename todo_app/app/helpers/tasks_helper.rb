module TasksHelper
  def display_sort_val(sort_val)
    sort_val.eql?(:desc) ? :asc : :desc
  end
end
