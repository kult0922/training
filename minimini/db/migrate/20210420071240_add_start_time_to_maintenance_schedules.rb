class AddStartTimeToMaintenanceSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :maintenance_schedules, :reason, :string
    add_column :maintenance_schedules, :start_time, :datetime
    add_column :maintenance_schedules, :end_time, :datetime
  end
end
