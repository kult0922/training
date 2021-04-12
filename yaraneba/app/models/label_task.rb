# frozen_string_literal: true

class LabelTask < ApplicationRecord
  belongs_to :label
  belongs_to :task

  def self.create_labeltasks(label_ids, task_id)
    label_ids.each do |l|
      LabelTask.create(label_id: l, task_id: task_id)
    end
  end
end
