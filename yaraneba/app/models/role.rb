# frozen_string_literal: true

class Role < ApplicationRecord
  ROLE_ADMIN = 'admin'
  ROLE_MEMBER = 'member'
  has_many :users, dependent: :nullify
end
