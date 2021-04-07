class Task < ApplicationRecord
    validates :name, presence: true
    validates :description, presence: true
    validates :due_date, presence: true
    
    enum status: { '未着手': 0, '着手中': 1, '完了': 2 }
    enum labels: { 
        'A: 重要度高': "1",
        'B: 重要度低': "2",
        'C: 緊急度高': "3",
        'D: 緊急度低': "4"
    }

    def self.searchAll(user_id)
        @tasks = Task.where(user_id: user_id)
    end
end
