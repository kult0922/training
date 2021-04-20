require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.build(:user)
  end

  it 'is valid with email, password_digest' do
    expect(@user).to be_valid
  end

  it 'is invalid without a name' do
    @user.name = nil
    expect(@user).to be_invalid
    expect(@user.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a email' do
    @user.email = nil
    expect(@user).to be_invalid
    expect(@user.errors[:email]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a password_digest' do
    @user.password_digest = nil
    expect(@user).to be_invalid
    expect(@user.errors[:password_digest]).to include(I18n.t('errors.messages.blank'))
  end

  it "is invalid with long email over 64 character" do
    @user.email = "x" * 65
    expect(@user).to be_invalid
  end

  it "is invalid with long password_digest over 64 character" do
    @user.password_digest = "x" * 65
    expect(@user).to be_invalid
  end
end
