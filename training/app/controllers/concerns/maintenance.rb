# frozen_string_literal: true

module Maintenance
  extend ActiveSupport::Concern

  MAINTENANCE_FILE = Rails.root.join('tmp', 'maintenance', 'timing.txt')

  included do
    before_action :do_maintenance
  end

  def maintenance_mode?
    File.exist?(MAINTENANCE_FILE)
  end

  def get_maintenance_period
    maintenance_time = []
    File.open(MAINTENANCE_FILE, 'r') do |file|
      file.each_line do |line|
        maintenance_time.push(line.split(' => '))
      end
    end

    maintenance_time.to_h
  end

  def maintenance_period?
    maintenance_time = get_maintenance_period
    maintenance_time['start_at'].in_time_zone <= Time.zone.now && maintenance_time['end_at'].in_time_zone > Time.zone.now
  end

  def do_maintenance
    return if maintenance_mode? && maintenance_period?

    maintenance_time = get_maintenance_period
    render 'maintenance/normal', locals: { start_at: maintenance_time['start_at'], end_at: maintenance_time['end_at'] }
  end
end
