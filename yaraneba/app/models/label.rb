# frozen_string_literal: true

class Label < ApplicationRecord
  belongs_to :user
  has_many :label_tasks, dependent: :destroy
  has_many :tasks, through: :label_tasks

  def self.create_labels(labels, user_id)
    label_ids = []

    labels.each do |l|
      label = Label.find_or_create_by!(name: l, user_id: user_id)
      label_ids.push(label.id)
    end

    label_ids
  end
end
