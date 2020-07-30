# frozen_string_literal: true

class Project < ApplicationRecord
  enum status: { todo: 0, in_progress: 1, in_review: 2, release: 3, done: 4 }
  has_many :tasks, dependent: :destroy
end
