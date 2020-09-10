class User < ApplicationRecord
  has_many :tasks, dependent: :delete_all

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 256 }
end
