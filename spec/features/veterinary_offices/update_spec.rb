require 'rails_helper'

RSpec.describe 'the vet office update' do
  before :each do
    @vet_office = FactoryBot.create(:veterinary_office, boarding_services: true)
    visit "/veterinary_offices/#{@vet_office.id}/edit"
  end

  it "shows the vet office edit form" do
    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('Max patient capacity')
    expect(find('form')).to have_content('Boarding services')
  end

  context "given valid data" do
    it "submits the edit form and updates the vet office" do
      within 'form' do
        fill_in 'Name', with: 'Wichita vet office'
        uncheck 'Boarding services'
        fill_in 'Max patient capacity', with: 10
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
        fill_in 'Name', with: ''
        click_button
      end

      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_current_path("/veterinary_offices/#{@vet_office.id}/edit")
    end
  end
end
