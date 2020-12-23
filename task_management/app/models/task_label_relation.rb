class TaskLabelRelation < ApplicationRecord
  belongs_to :task_label, polymorphic: true
end
