require 'rails_helper'

RSpec.describe 'veterinarian creation' do
  before(:all) do
    @vet_office = VeterinaryOffice.create(name: 'Best Vets', boarding_services: true, max_patient_capacity: 20)
  end

  before :each do
    visit "/veterinary_offices/#{@vet_office.id}/veterinarians/new"
  end

  after :all do
    VeterinaryOffice.destroy_all
  end

  describe 'the veterinarian new' do
    it 'renders the new form' do
      expect(page).to have_content('New Veterinarian')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Review rating')
      expect(find('form')).to have_content('On call')
    end
  end

  describe 'the veterinarian create' do
    context 'given valid data' do
      it 'creates the vet and redirects to the veterinary offices vet index' do
        within 'form' do
          fill_in 'veterinarian_name', with: 'Dr. Burstyn'
          fill_in 'veterinarian_review_rating', with: 10
          check 'veterinarian_on_call'
          click_button
        end

        expect(page).to have_current_path(
          "/veterinary_offices/#{@vet_office.id}/veterinarians"
        )
        expect(page).to have_content('Dr. Burstyn')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        within 'form' do
          click_button
        end

        expect(page).to have_current_path(
          "/veterinary_offices/#{@vet_office.id}/veterinarians/new"
        )
        expect(page).to have_content("Error: Name can't be blank, Review rating can't be blank, Review rating is not a number")
      end
    end
  end
end
