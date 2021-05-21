require 'rails_helper'

RSpec.describe 'the vet office update' do
  before :all do
    @vet_office = FactoryBot.create(:veterinary_office, boarding_services: true)
  end

  before :each do
    visit "/veterinary_offices/#{@vet_office.id}/edit"
  end

  after :all do
    VeterinaryOffice.destroy_all
  end

  it "shows the vet office edit form" do
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Max patient capacity')
    expect(find('form')).to have_content('Boarding services')
  end

  context "given valid data" do
    it "submits the edit form and updates the vet office" do
      within 'form' do
        fill_in 'veterinary_office_name', with: 'Wichita vet office'
        uncheck 'veterinary_office_boarding_services'
        fill_in 'veterinary_office_max_patient_capacity', with: 10
        click_button
      end

      expect(page).to have_current_path('/veterinary_offices')
      expect(page).to have_content('Wichita vet office')
      expect(page).to_not have_content(@vet_office.name)
    end
  end

  context "given invalid data" do
    it 're-renders the edit form' do
      within 'form' do
        fill_in 'veterinary_office_name', with: ''
        click_button
      end

      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_current_path("/veterinary_offices/#{@vet_office.id}/edit")
    end
  end
end
