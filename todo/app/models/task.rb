# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { '小': 0, '中': 1, '高': 2 }
  belongs_to :project
end
