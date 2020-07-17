# frozen_string_literal: true

require 'rails_helper'

describe AppUser, type: :model do
  it 'Validation success' do
    app_user = FactoryBot.build(:app_user)

    expect(app_user).to be_valid
  end

  it 'Empty pass' do
    app_user = FactoryBot.build(:app_user)
    app_user.password = nil

    expect(app_user).not_to be_valid
  end
end
