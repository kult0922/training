class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 105 }
  has_many :tasks
end
