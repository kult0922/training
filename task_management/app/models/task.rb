class Task < ApplicationRecord
  enum priority: { low: 0, normal: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
end
