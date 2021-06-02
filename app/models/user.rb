# frozen_string_literal: true

class User < ApplicationRecord
  PASSWORD_REQUIREMENTS = /\A
    (?=.*\d) # Contain at least one number
    (?=.*[a-z]) # Contain at least one lowercase letter
    (?=.*[A-Z]) # Contain at least one uppercase letter
    (?=.*[[:^alnum:]]) # Contain at least one symbol
  /x

  has_many :tasks, dependent: :destroy
  has_many :labels, dependent: :destroy
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, format: PASSWORD_REQUIREMENTS
end
