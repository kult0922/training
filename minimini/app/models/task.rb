class Task < ApplicationRecord
  with_options presence: true do
    validates :name
    validates :description
    validates :due_date
  end

  enum status: {
    not_selected: 1,
    not_started: 2,
    in_progress: 3,
    completed: 4,
  }
  enum labels: {
    very_important: 1,
    important: 2,
    urgent: 3,
    normal: 4,
  }

  enum sort_order: { asc: "ASC", desc: "DESC" }, _default: :desc

  belongs_to :user

  def self.search(search_params, current_user_id)
    unless search_params.blank?
      sort_order = Task.human_attribute_enum_value(
        :sort_order,
        search_params.sort_order).upcase

        # ステータースが「選択なし」
        if search_params.status == "#{Task.statuses[:not_selected]}"
          @tasks = Task.preload(:user).where(
            user_id: current_user_id).order(id: sort_order)
        else 
          @tasks = Task.preload(:user).where(
            user_id: current_user_id,
            status: search_params.status).order(id: sort_order)
        end
    else
      @tasks = Task.preload(:user).where(user_id: current_user_id)
    end
  end
end
