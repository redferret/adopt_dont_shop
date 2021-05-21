require 'rails_helper'

RSpec.describe 'the veterinarian update' do
  before :all do
    @shelter = Shelter.create(name: 'Hollywood shelter', city: 'Irvine, CA', foster_program: false, rank: 7)
    @pet = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'George Hairlesson', shelter_id: @shelter.id)
  end

  before :each do
    visit "/pets/#{@pet.id}/edit"
  end

  after :all do
    Shelter.destroy_all
  end

  it "shows the veterinarian edit form" do
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Breed')
    expect(find('form')).to have_content('Adoptable')
    expect(find('form')).to have_content('Age')
  end

  context "given valid data" do
    it "submits the edit form and updates the veterinarian" do
      within 'form' do
        fill_in 'pet_name', with: 'Itchy'
        uncheck 'pet_adoptable'
        fill_in 'pet_age', with: 1
        click_button
      end

      expect(page).to have_current_path("/pets/#{@pet.id}")
      expect(page).to have_content('Itchy')
      expect(page).to_not have_content('Charlie')
    end
  end

  context "given invalid data" do
    it 're-renders the edit form' do
      within 'form' do
        fill_in 'pet_name', with: ''
        click_button
      end

      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_current_path("/pets/#{@pet.id}/edit")
    end
  end
end
