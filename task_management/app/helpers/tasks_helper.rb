# frozen_string_literal: true

# タスク ヘルパー
module TasksHelper
  def sort_link_to(sort_key, order)
    if order == 'DESC'
      icon_img = 'sort/desc_icon.png'
      sort_id = sort_key + '_asc'
      sort_order = 'ASC'
    else
      icon_img = 'sort/asc_icon.png'
      sort_id = sort_key + '_desc'
      sort_order = 'DESC'
    end

    link_to image_tag(icon_img, class: 'sort_icon'),
            { controller: 'tasks', action: 'index',
              sort: sort_key,
              order: sort_order },
            id: sort_id
  end

  def delete_button_to(path)
    button_to I18n.t('tasks.index.btn_delete'), path,
              method: :delete,
              data: { confirm: I18n.t('tasks.index.confirm_delete'),
                      disable_with: I18n.t('tasks.index.load_delete') }
  end
end
