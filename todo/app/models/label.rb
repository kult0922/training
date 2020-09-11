# frozen_string_literal: true

class Label < ApplicationRecord
  has_many :tasks, through: :task_labels
  has_many :task_labels, dependent: :destroy

  validates :color, presence: true, format: { with: /\A#[a-zA-Z0-9]{6}\z/ }
  validates :text, presence: true
end
