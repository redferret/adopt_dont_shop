FactoryBot.define do
  factory :application do
    description { Faker::Lorem.sentence }
    status { 'In Progress' }
  end
end
