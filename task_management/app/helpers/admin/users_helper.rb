# frozen_string_literal: true

# ユーザヘルパー
module Admin
  module UsersHelper
    def tasks_link_to(user)
      link_to user.tasks.ids.count, admin_user_path(user),
              { onclick: "window.open(this.href,
                                     'new_window_#{user.id}',
                                     'height=600px, width=1000px');
                                     return false;",
                id: "show_task_link_#{user.id}" }
    end
  end
end
