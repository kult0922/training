FactoryBot.define do
  factory :user do
    login_id { 'test_user_1' }
    name { '奥野' }
    password { 'pass' }
    authority_id { create(:authority).id }
  end
end
