class Task < ApplicationRecord
    with_options presence: true do
      validates :name
      validates :description
      validates :due_date
    end
    
    enum status: { '未着手': 0, '着手中': 1, '完了': 2 }
    enum labels: { 
        'A: 重要度高': "1",
        'B: 重要度低': "2",
        'C: 緊急度高': "3",
        'D: 緊急度低': "4"
    }

    belongs_to :user
end
