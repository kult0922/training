FactoryBot.define do
  factory :label do
    user_id { create(:user).id }
    sequence :name do |n|
      'test_label_1'
    end
  end
end
