# frozen_string_literal: true

class Label < ApplicationRecord
  enum color: { sky: 0, blue: 1, green: 2, gray: 3, yellow: 4, red: 5, black: 6 }
  has_many :tasks, through: :task_labels
  has_many :task_labels, dependent: :destroy
end
