# frozen_string_literal: true

module TasksHelper
  def label_color(color)
    case color.to_sym
    when :red then
      'badge badge-danger'
    when :gray then
      'badge badge-secondary'
    when :green then
      'badge badge-success'
    when :yellow then
      'badge badge-warning'
    when :blue then
      'badge badge-primary'
    when :sky then
      'badge badge-info'
    else
      'badge badge-dark'
    end
  end

  def label_text(color)
    case color.to_sym
    when :red then
      '要対応'
    when :gray then
      '遅れ'
    when :green then
      '完了見込み'
    when :yellow then
      '要注意'
    when :blue then
      '完了'
    when :sky then
      'レビュー依頼'
    else
      '不明'
    end
  end
end
