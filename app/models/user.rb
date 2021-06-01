# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { in: 8..20 }
end
