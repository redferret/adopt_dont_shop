5.times do
  vet_office = FactoryBot.create(:veterinary_office)

  rand(3..7).times do
    FactoryBot.create(:veterinarian, veterinary_office: vet_office)
  end
end if VeterinaryOffice.count == 0

8.times do
  shelter = FactoryBot.create(:shelter)

  3.times do
    FactoryBot.create(:pet, shelter: shelter)
  end
end if Shelter.count == 0

# select shelters starting at first.id to (first.id + 3)
shelter_id = Shelter.first.id
3.times do
  application = FactoryBot.create(:application, status: 'In Progress')
  applicant = FactoryBot.create(:applicant, application: application)
  address = FactoryBot.create(:address, applicant: applicant)

  random_shelter = Shelter.find(shelter_id)
  shelter_id += 1
  2.times do
    random_pet = random_shelter.pets.sample
    application.pets << random_pet if !application.pets.include?(random_pet)
    ApplicationsPets.where({pet_id: random_pet.id, application_id: application.id}).update_all(status: 'pending')
  end
end if Application.count == 0

# select shelters starting at (first.id + 3) to (first.id + 6)
3.times do
  application = FactoryBot.create(:application, status: 'Pending')
  applicant = FactoryBot.create(:applicant, application: application)
  address = FactoryBot.create(:address, applicant: applicant)

  random_shelter = Shelter.find(shelter_id)
  shelter_id += 1
  2.times do
    random_pet = random_shelter.pets.sample
    application.pets << random_pet if !application.pets.include?(random_pet)
    ApplicationsPets.where({pet_id: random_pet.id, application_id: application.id}).update_all(status: 'pending')
  end
end if Application.count == 3
