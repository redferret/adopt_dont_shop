FactoryBot.define do
  factory :veterinarians do
    on_call { Faker::Boolean.boolean }
    review_rating { rand(5) }
    name { Faker::Name.name }
  end
end
