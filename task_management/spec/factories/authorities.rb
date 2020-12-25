FactoryBot.define do
  factory :authority do
    sequence :role, &:to_s
    sequence :name do |n|
      'test_role_1'
    end
  end
end
