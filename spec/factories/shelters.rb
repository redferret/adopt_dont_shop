FactoryBot.define do
  factory :shelter do
    foster_program { Faker::Boolean.boolean }
    name { Faker::Company.name }
    city { Faker::Address.city }
    rank { rand(1..10) }
  end
end
