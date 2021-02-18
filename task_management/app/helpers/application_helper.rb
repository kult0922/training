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

  def edit_icon_to(path, html_id)
    link_to image_tag('operation/edit_icon.png', class: 'icon edit_icon'), path,
            { id: "edit_link_#{html_id}" }
  end

  def delete_icon_to(path, html_id)
    link_to image_tag('operation/delete_icon.png', class: 'icon delete_icon'), path,
            { method: :delete,
              data: { confirm: I18n.t('admin.users.index.confirm_delete') },
              id: "delete_link_#{html_id}" }
  end

  def logout_button_to(user)
    button_to I18n.t('layouts.common.logout'), logout_path(user),
              { method: :delete,
                data: { confirm: I18n.t('layouts.common.confirm_logout'),
                        disable_with: I18n.t('layouts.common.load_logout') } }
  end
end
