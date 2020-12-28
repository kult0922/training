# frozen_string_literal: true

module ApplicationHelper
  def page_title
    title = 'タスク管理システム'
    title = "#{@page_title} | #{title}" if @page_title
    title
  end
end
