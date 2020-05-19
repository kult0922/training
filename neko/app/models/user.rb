class User < ApplicationRecord
  validates :name, presence: true

  has_many :tasks, dependent: :destroy
  has_one :auth_info, dependent: :destroy
  accepts_nested_attributes_for :auth_info
end
