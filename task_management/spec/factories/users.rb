FactoryBot.define do
  factory :user do
    sequence(:login_id) { 'test_user_1' }
    sequence(:name) { 'test_name_1' }
    password { 'pass' }
    authority_id { create(:authority).id }
  end
end
