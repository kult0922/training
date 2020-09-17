class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  # ユーザーと権限の組み合わせはユニーク
  validates :user_id, uniqueness: { scope: :role_id}

end
