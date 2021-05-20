FactoryBot.define do
  factory :address do
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zipcode { Faker::Address.zip }
  end

  factory :invalid_address do
    street { '' }
    city { '' }
    state { '' }
    zipcode { '' }
  end
end
