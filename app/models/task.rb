# frozen_string_literal: true

class Task < ApplicationRecord
  include AASM

  enum aasm_state: {
    ready: 0,
    doing: 1,
    done: 2
  }

  aasm column: :aasm_state, enum: true do
    state :ready, initial: true, display: I18n.t('activerecord.states.task.ready')
    state :doing, display: I18n.t('activerecord.states.task.doing')
    state :done, display: I18n.t('activerecord.states.task.done')

    event :start do
      transitions from: :ready, to: :doing
    end

    event :complete do
      transitions from: :doing, to: :done
    end
  end
  validates :title, presence: true, length: { maximum: 30 }
  validates :priority, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: true
end
