class User < ApplicationRecord
  validates :name, presence: true

  has_many :tasks, dependent: :delete_all
  has_one :auth_info, dependent: :destroy
  accepts_nested_attributes_for :auth_info

  enum role: { administrator: 0, general_user: 1 }
end
