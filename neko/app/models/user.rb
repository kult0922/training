class User < ApplicationRecord
  validates :name, presence: true
  
  has_many :tasks
  belongs_to :auth_info
end
