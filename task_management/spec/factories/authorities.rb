FactoryBot.define do
  factory :authority do
    sequence :role do |n|
      n
    end
    sequence :name do |n|
      'test_role_1'
    end
  end
end
