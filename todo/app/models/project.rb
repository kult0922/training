# frozen_string_literal: true

class Project < ApplicationRecord
  enum status: { 'To Do': 0, 'In Progress': 1, 'In Review': 2, 'Waiting Approval / Release': 3, 'Resolved / Done': 4 }
  has_many :tasks
end
