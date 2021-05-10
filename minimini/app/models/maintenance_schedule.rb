class MaintenanceSchedule < ApplicationRecord
  with_options presence: true do
    validates :reason
    validates :start_time
    validates :end_time
  end

  def self.has_scheduled_maintenance?
    now = Time.zone.now
    MaintenanceSchedule.where('start_time <= ? and end_time >= ?', now, now).any?
  end
end
