FactoryBot.define do
  factory :veterinary_office do
    boarding_services { Faker::Boolean.boolean }
    max_patient_capacity { rand(5..20) }
    name { Faker::Company.name }
  end
end
