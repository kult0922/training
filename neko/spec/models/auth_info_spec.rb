require 'rails_helper'

RSpec.describe AuthInfo, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  context 'email address entered is a duplicate' do
    it 'raise a error' do
      auth = AuthInfo.create!(email: 'test@example.com', password: 'testpassword', user: user1)
      duplicate_auth = AuthInfo.new(email: auth.email, password: auth.password, user: user2)
      expect(duplicate_auth.valid?).to eq false
      expect(duplicate_auth.errors.full_messages).to eq ['メールアドレスはすでに存在します']
    end
  end
end
