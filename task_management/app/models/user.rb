class User < ApplicationRecord
  belongs_to :authority
  has_many :tasks
  has_many :label
end
