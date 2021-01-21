# frozen_string_literal: true

# タスク ヘルパー
module TasksHelper
  def sort_link_to(sort)
    if sort == 'deadline DESC'
      link_to image_tag('sort/desc_icon.png', class: 'sort_icon'),
              { controller: 'tasks', action: 'index',
                sort: 'deadline' },
              id: 'deadline_asc'
    else
      link_to image_tag('sort/asc_icon.png', class: 'sort_icon'),
              { controller: 'tasks', action: 'index',
                sort: 'deadline DESC' },
              id: 'deadline_desc'
    end
  end

  def delete_button_to(path)
    button_to I18n.t('tasks.index.btn_delete'), path,
              method: :delete,
              data: { confirm: I18n.t('tasks.index.confirm_delete'),
                      disable_with: I18n.t('tasks.index.load_delete') }
  end
end
