# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :tasks
  validates :last_name, presence: true, length: { maximum: 25 }
  validates :first_name, presence: true, length: { maximum: 25 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password_digest, presence: true

  # メールの保存時に、大文字を小文字化(わかりやすくする為、右辺のselfは省略しない)
  before_save { self.email = self.email.downcase }
end
