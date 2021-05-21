require 'rails_helper'

RSpec.describe 'vet office creation' do
  describe 'the vet office new' do
    it 'renders the new form' do
      visit '/veterinary_offices/new'

      expect(page).to have_content('New Vet Office')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Max patient capacity')
      expect(find('form')).to have_content('Boarding services')
    end
  end

  describe 'the vet office create' do
    context 'given valid data' do
      it 'creates the vet office' do
        visit '/veterinary_offices/new'

        within 'form' do
          fill_in 'veterinary_office_name', with: 'Houston Vet Office'
          fill_in 'veterinary_office_max_patient_capacity', with: 75
          check 'veterinary_office_boarding_services'
          click_button
        end

        expect(page).to have_current_path('/veterinary_offices')
        expect(page).to have_content('Houston Vet Office')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        visit '/veterinary_offices/new'
        within 'form' do
          click_button
        end

        expect(page).to have_content("Error: Name can't be blank, Max patient capacity can't be blank, Max patient capacity is not a number")
        expect(page).to have_current_path('/veterinary_offices/new')
      end
    end
  end
end
