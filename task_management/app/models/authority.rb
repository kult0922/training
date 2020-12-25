class Authority < ApplicationRecord
  has_many :users

  validates :role, presence: true, length: { maximum: 1 }, uniqueness: true
  validates :name, presence: true, length: { maximum: 25 }
end
