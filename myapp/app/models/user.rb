class User < ApplicationRecord
  has_many :tasks, foreign_key: :user_id, dependent: :delete_all

  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, confirmation: true, on: :create

end
