# frozen_string_literal: true

module TasksHelper
  STATUS_STR = I18n.t('enum.task.status').freeze

  STATUS_SELECT = STATUS_STR.each_with_index

  def to_status_str(str)
    STATUS_STR[str]
  end

  def status_select
    STATUS_SELECT
  end

  def sort_directions
    {
      desc: 'desc',
      asc: 'asc',
    }
  end
end
