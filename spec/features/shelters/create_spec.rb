require 'rails_helper'

RSpec.describe 'shelter creation' do
  before :each do
    visit '/shelters/new'
  end

  after :all do
    Shelter.destroy_all
  end

  describe 'the shelter new' do
    it 'renders the new form' do
      expect(page).to have_content('New Shelter')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('City')
      expect(find('form')).to have_content('Rank')
      expect(find('form')).to have_content('Foster program')
    end
  end

  describe 'the shelter create' do
    context 'given valid data' do
      it 'creates the shelter' do
        within 'form' do
          fill_in 'shelter_name', with: 'Houston Shelter'
          fill_in 'shelter_city', with: 'Houston'
          check 'shelter_foster_program'
          fill_in 'shelter_rank', with: 7
          click_button
        end

        expect(page).to have_current_path('/shelters')
        expect(page).to have_content('Houston Shelter')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        within 'form' do
          click_button
        end

        expect(page).to have_content("Error: Name can't be blank, Rank can't be blank, Rank is not a number")
        expect(page).to have_current_path('/shelters/new')
      end
    end
  end
end
