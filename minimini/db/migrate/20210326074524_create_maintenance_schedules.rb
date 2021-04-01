class CreateMaintenanceSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :maintenance_schedules do |t|

      t.timestamps
    end
  end
end
