# frozen_string_literal: true

class User < ApplicationRecord
  has_many :user_projects, dependent: :nullify
  has_many :tasks, dependent: :nullify
  has_secure_password

  validates :password, length: { minimum: 6 }
  validates :account_name, format: { with: /\A[a-zA-Z0-9]+\z/ }
  validates :account_name, uniqueness: true
end
