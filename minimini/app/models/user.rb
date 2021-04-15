class User < ApplicationRecord
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 64 }
  validates :email, presence: true, length: { maximum: 64 }
  validates :password_digest, presence: true, length: { maximum: 64 }

  has_many :tasks

  has_secure_password
end
