# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  belongs_to :role, optional: true

  validates :email, presence: true

  has_secure_password

  enum role_id: { admin: 1, member: 2 }
end
