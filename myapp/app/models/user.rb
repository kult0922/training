# frozen_string_literal: true

class User < ApplicationRecord
  # generate a hash of the secure password
  has_secure_password

  has_many :tasks, dependent: :delete_all

  validates :name, presence: true
  validates :email, presence: true, length: { maximum: 256 }, uniqueness: { message: I18n.t('errors.messages.duplicate') }
end
