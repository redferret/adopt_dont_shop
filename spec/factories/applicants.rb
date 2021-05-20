FactoryBot.define do
  factory :applicant do
    name { Faker::Name.name }
  end
end
