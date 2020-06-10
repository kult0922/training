class User < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, length: { in: 4..15 }

  has_many :tasks, dependent: :delete_all
  has_one :auth_info, dependent: :destroy
  accepts_nested_attributes_for :auth_info
end
