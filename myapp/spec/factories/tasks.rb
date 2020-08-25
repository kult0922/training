FactoryBot.define do
	factory :task do
    title { Faker::Device.model_name }
    discription { ["discription1","discription2"].sample }
  end
end
