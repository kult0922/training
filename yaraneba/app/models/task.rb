# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  enum status: { waiting: 0, working: 1, completed: 2 }
  NEED_FUZZY = ['title'].freeze

  validates :title, presence: true
  validate :date_check

  def date_check
    now_date = Time.zone.today.strftime('%Y-%m-%d')
    err_msg = I18n.t('errors.messages.greater_than_or_equal_to', count: now_date)
    errors.add(I18n.t('tasks.common.end_date'), err_msg) if self.end_date.to_s < now_date
  end

  def self.search(request, user_id)
    params = request.query_parameters.except(:direction, :sort)
    @tasks = Task.where(user_id: user_id)
    params.each do |k, v|
      next if v.blank?

      @tasks =
        if NEED_FUZZY.include?(k)
          @tasks.where("#{k} LIKE ?", "%#{v}%")
        else
          @tasks.where("#{k}": v)
        end
    end
    @tasks
  end
end
