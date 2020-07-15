class User < ApplicationRecord
  before_save { self.mail_address = mail_address.downcase }

  has_secure_password
  has_many :tasks, dependent: :destroy

  enum role: { admin: 0, general: 1 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[\d])\w{6,100}\z/.freeze

  validates :name, presence: true
  validates :mail_address, {
    presence: true, format: { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false },
  }
  validates :password, presence: true,
                       format: {
                         with: VALID_PASSWORD_REGEX,
                         message: I18n.t('errors.message.invalid_mail_address'),
                       }, allow_nil: true
end
