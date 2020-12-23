class Label < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, as: :task_label
end
