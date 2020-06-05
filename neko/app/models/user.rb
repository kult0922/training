class User < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, length: { in: 4..15 }

  has_many :tasks, dependent: :delete_all
end
