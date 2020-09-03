require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid without name, email and password' do
    new_user = User.new()
    new_user.valid?
    expect(new_user.errors.messages[:name]).to include('を入力してください')
    expect(new_user.errors.messages[:email]).to include('を入力してください')
    expect(new_user.errors.messages[:password]).to include('を入力してください')
  end
end
