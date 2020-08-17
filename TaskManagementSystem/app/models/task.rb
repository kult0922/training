class Task < ApplicationRecord
	enum status: { waiting: 0, working: 1, completed: 2}
end
