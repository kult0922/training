# frozen_string_literal: true

# 権限マスタ
class Authority < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :role, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
