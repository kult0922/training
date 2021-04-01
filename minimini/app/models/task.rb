class Task < ApplicationRecord
    enum status: { 'Not Started': 0, 'Work In Progress': 1, 'Done': 2 }
    enum labels: { 
        'A: 重要度高': "1",
        'B: 重要度低': "2",
        'C: 緊急度高': "3",
        'D: 緊急度低': "4"
     }

    def self.search(user_id)
        @tasks = Task.where(user_id: user_id)
    end

    def self.update(user_id)
        @tasks = Task.update(user_id: user_id)
    end
end
