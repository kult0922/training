require 'rails_helper'

RSpec.describe MaintenanceSchedule, type: :model do
  before(:each) do
    @maintenance_schedule = FactoryBot.build(:maintenance_schedule)
  end

  it 'is valid with reason, start_time, end_time' do
    expect(@maintenance_schedule).to be_valid
  end

  it 'is invalid without a reason' do
    @maintenance_schedule.reason = nil
    expect(@maintenance_schedule).to be_invalid
    expect(@maintenance_schedule.errors[:reason]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a start_time' do
    @maintenance_schedule.start_time = nil
    expect(@maintenance_schedule).to be_invalid
    expect(@maintenance_schedule.errors[:start_time]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a end_time' do
    @maintenance_schedule.end_time = nil
    expect(@maintenance_schedule).to be_invalid
    expect(@maintenance_schedule.errors[:end_time]).to include(I18n.t('errors.messages.blank'))
  end
end
