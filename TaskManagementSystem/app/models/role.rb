class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  
  validates :name, presence: true
end
