class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  
  validates :name, presence: true, length: { maximum: 25 }
end
