# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :tasks, through: :labellings
  has_many :task_labels, dependent: :destroy
end
