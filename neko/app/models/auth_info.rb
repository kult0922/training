class AuthInfo < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { message: '名前はフルネームで入力してください' }, format: { with: VALID_EMAIL_REGEX }
  has_secure_password

  belongs_to :user, dependent: :destroy
end
