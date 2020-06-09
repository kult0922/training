class User < ApplicationRecord
  paginates_per 10

  has_secure_password
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
end
