5.times do
  vet_office = FactoryBot.create(:veterinary_office)

  rand(3..7).times do
    FactoryBot.create(:veterinarian, veterinary_office: vet_office)
  end
end

5.times do
  shelter = FactoryBot.create(:shelter)

  rand(10..20).times do
    FactoryBot.create(:pet, shelter: shelter)
  end
end

5.times do
  application = FactoryBot.create(:application, status: 'In Progress', description: '')
  applicant = FactoryBot.create(:applicant, application: application)
  address = FactoryBot.create(:address, applicant: applicant)

  rand(1..5).times do
    random_shelter = Shelter.all.sample
    random_pet = random_shelter.pets.sample
    application.pets << random_pet
  end
end


2.times do
  application = FactoryBot.create(:application, status: 'Pending')
  applicant = FactoryBot.create(:applicant, application: application)
  address = FactoryBot.create(:address, applicant: applicant)

  3.times do
    random_shelter = Shelter.all.sample
    random_pet = random_shelter.pets.sample
    application.pets << random_pet
  end
end
