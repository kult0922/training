require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with email, password_digest' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = FactoryBot.build(:user)
    user.name = nil
    expect(user).to be_invalid
    expect(user.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a email' do
    user = FactoryBot.build(:user)
    user.email = nil
    expect(user).to be_invalid
    expect(user.errors[:email]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a password_digest' do
    user = FactoryBot.build(:user)
    user.password_digest = nil
    expect(user).to be_invalid
    expect(user.errors[:password_digest]).to include(I18n.t('errors.messages.blank'))
  end

  it "is invalid with long email over 64 character" do
    @user = FactoryBot.build(:user, email: "x" * 65)
    expect(@user).to be_invalid
  end

  it "is invalid with long password_digest over 64 character" do
    @user = FactoryBot.build(:user, password_digest: "x" * 65)
    expect(@user).to be_invalid
  end
end
