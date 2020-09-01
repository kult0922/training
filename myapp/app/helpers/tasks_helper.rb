# frozen_string_literal: true

module TasksHelper
  def sort_by(column)
    column_name = t('.' + column)

    direction = params[:sort] == column && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to column_name, sort: column, direction: direction
  end
end
