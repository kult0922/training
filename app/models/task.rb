class Task < ApplicationRecord
  enum status: { 未着手: 10, 着手: 20, 完了: 30 }
end
