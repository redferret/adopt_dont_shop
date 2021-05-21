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
