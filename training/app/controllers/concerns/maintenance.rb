# frozen_string_literal: true

module Maintenance
  extend ActiveSupport::Concern

  MAINTENANCE_FILE = Rails.root.join('tmp', 'maintenance', 'timing.yml')

  included do
    before_action :do_maintenance
  end

  def maintenance_time
    return unless File.exist?(MAINTENANCE_FILE)

    data = File.open(MAINTENANCE_FILE, 'r') { |file| YAML.safe_load(file) }
    data['start_at'] = data['start_at'].in_time_zone
    data['end_at'] = data['end_at'].in_time_zone

    data
  end

  def maintenance_mode?
    period = maintenance_time
    return false if period.blank?
    period['start_at'] <= Time.zone.now && period['end_at'] > Time.zone.now
  end

  def do_maintenance
    return unless maintenance_mode?
    period = maintenance_time
    render 'maintenance/normal', layout: false, locals: { start_at: period['start_at'], end_at: period['end_at'] }
  end
end
