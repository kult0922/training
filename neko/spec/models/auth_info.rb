require 'rails_helper'

RSpec.describe Status, type: :model do
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  context 'email address entered is a duplicate' do
    it 'raise a error' do
      create(:auth_info, email: 'test@example.com')
      a = create(:auth_info, email: 'test@example.com')
      expect(t.errors.full_messages).to eq ['メールアドレスはすでに存在します']
    end
  end
end
