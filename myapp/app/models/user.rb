# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all

  validates :account, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 4 }
  validates :password, length: { minimum: 4 }

  enum role: %i[user admin]

  before_destroy :ensure_atleast_one_admin

  def readable_role
    User.human_attribute_name("role.#{self.role}")
  end

  def self.readable_roles
    User.roles.map { |k, _| [User.human_attribute_name("role.#{k}"), k] }.to_h
  end

  private

  def ensure_atleast_one_admin
    return unless admin? && User.where(role: 'admin').count == 1
    errors[:base] << I18n.t(:need_atleast_one_admin)
    throw :abort
  end
end