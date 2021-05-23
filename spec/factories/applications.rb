FactoryBot.define do
  factory :application do
    description { Faker::Lorem.sentence }
    status { 'New' }
  end
end
