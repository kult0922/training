class Label < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user }, length: { maximum: 30 }
  belongs_to :user
end
