FactoryBot.define do
  factory :pet do
    name { Faker::Creature::Dog.name }
    age { rand(0..15) }
    breed { Faker::Creature::Dog.breed }
    adoptable { true }
  end
end
