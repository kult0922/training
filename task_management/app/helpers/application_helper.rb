# frozen_string_literal: true

# アプリケーションヘルパー
module ApplicationHelper
  def show_date(time)
    return time unless time
    time.strftime('%Y-%m-%d')
  end

  def show_date_s(time)
    return time unless time
    time.strftime('%Y/%m/%d')
  end

  def show_date_time_s(time)
    return time unless time
    time.strftime('%Y/%m/%d %H:%M:%S')
  end
end
