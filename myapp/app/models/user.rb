class User < ApplicationRecord
  has_many :tasks, foreign_key: :user_id, dependent: :delete_all

  def task_count
    tasks.loaded? ? tasks.to_a.count : tasks.count
  end

  has_secure_password

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

end
