FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Dog.name }
    age { rand(0..15) }
    breed { Faker::Creature::Dog.breed }
    adoptable { Faker::Boolean.boolean }
  end
end
