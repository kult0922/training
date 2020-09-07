class User < ApplicationRecord
  # relation
  has_many :tasks, dependent: :delete_all

  # validation
  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 256 }
end
