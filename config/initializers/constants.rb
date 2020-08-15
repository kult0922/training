module TASK_STATUS
  TODO    = 0
  DOING   = 1 
  PENDING = 2
  DONE    = 3
  NAME    = {
    0 => "Todo",
    1 => "Doing",
    2 => "Pending",
    3 => "Done"
  }.freeze
end

module TASK_PRIORITY
  LOW    = 0
  MIDDLE = 1
  HIGH   = 2
  NAME    = {
    0 => "Low",
    1 => "Middle",
    2 => "High",
  }.freeze
end

module USER_ROLE
  GENERAL = 0 
  ADMIN   = 1
  NAME    = {
    0 => "General",
    1 => "Admin",
  }.freeze
end
