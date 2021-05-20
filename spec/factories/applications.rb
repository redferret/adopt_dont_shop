FactoryBot.define do
  factory :valid_application do
    description { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zipcode { Faker::Address.zip }
  end

  factory :invalid_application do
    street { '' }
    city { '' }
    state { '' }
    zipcode { '' }
  end
end
