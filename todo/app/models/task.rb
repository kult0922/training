# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { low: 0, mid: 1, high: 2 }
  belongs_to :project
  belongs_to :assignee, :class_name => 'User', :foreign_key => 'assignee_id'  
  belongs_to :reporter, :class_name => 'User', :foreign_key => 'reporter_id' 
end
