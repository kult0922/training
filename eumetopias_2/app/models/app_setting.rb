class AppSetting < ApplicationRecord
  validates :item, presence: true, uniqueness: { case_sensitive: true }
  validates :value, presence: true

  def self.maintenance_mode?
    return false unless setting = maintenance_mode_setting
    setting.value == 'true' ? true : false
  end

  def self.enable_maintenance_mode
    setting = maintenance_mode_setting
    if setting
      setting.value = 'true'
      setting.save
    else
      self.create(item: 'maintenance_mode', value: 'true')
    end
  end

  def self.disable_maintenance_mode
      setting = maintenance_mode_setting
      if setting
        setting.value = 'false'
        setting.save
      end
  end

  private
  def self.maintenance_mode_setting
    self.find_by(item: 'maintenance_mode') || false
  end
end
