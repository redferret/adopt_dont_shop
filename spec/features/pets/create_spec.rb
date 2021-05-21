require 'rails_helper'

RSpec.describe 'pet creation' do
  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
  end

  describe 'the pet new' do
    it 'renders the new form' do
      visit "/shelters/#{@shelter.id}/pets/new"

      expect(page).to have_content('New Pet')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Breed')
      expect(find('form')).to have_content('Age')
      expect(find('form')).to have_content('Adoptable')
    end
  end

  describe 'the pet create' do
    context 'given valid data' do
      it 'creates the pet and redirects to the shelter pets index' do
        visit "/shelters/#{@shelter.id}/pets/new"

        within 'form' do
          fill_in 'pet_name', with: 'Bumblebee'
          fill_in 'pet_age', with: 1
          fill_in 'pet_breed', with: 'Welsh Corgi'
          check 'pet_adoptable'
          click_button
        end

        expect(page).to have_current_path("/shelters/#{@shelter.id}/pets")
        expect(page).to have_content('Bumblebee')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        visit "/shelters/#{@shelter.id}/pets/new"

        within 'form' do
          click_button
        end

        expect(page).to have_current_path("/shelters/#{@shelter.id}/pets/new")
        expect(page).to have_content("Error: Name can't be blank, Age can't be blank, Age is not a number")
      end
    end
  end
end
