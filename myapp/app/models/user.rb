class User < ApplicationRecord
  include Enum
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true
  validates :role, presence: true
  before_destroy :valid_admin_for_destroy
  validate :valid_admin_for_update, on: :update

  enum role: { general: 0, admin: 1 }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def valid_admin
    return if 1 < User.where(role: 1).size
    errors.add(:role, I18n.t('admin.users.flash.admin_danger'))
    throw :abort
  end

  def valid_admin_for_destroy
    valid_admin if admin?
  end

  def valid_admin_for_update
    valid_admin if general?
  end
end
