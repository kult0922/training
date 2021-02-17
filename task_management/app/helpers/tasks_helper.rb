# frozen_string_literal: true

# タスク ヘルパー
module TasksHelper
  def sort_link_to(sort_key, order)
    order = 'ASC' if order.blank?
    icon_img = 'sort/' + order.downcase + '_icon.png'
    sort_id = sort_key + '_' + switch_order(order).downcase
    sort_order = switch_order(order)

    link_to image_tag(icon_img, class: 'sort_icon'),
            { controller: 'tasks', action: 'index',
              sort: sort_key,
              order: sort_order },
            id: sort_id
  end

  def switch_order(order)
    if order == 'DESC'
      'ASC'
    else
      'DESC'
    end
  end
end
