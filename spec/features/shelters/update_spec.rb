require 'rails_helper'

RSpec.describe 'the shelter update' do
  before :all do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
  end

  before :each do
    visit "/shelters/#{@shelter.id}/edit"
  end

  after :all do
    Shelter.destroy_all
  end
  it "shows the shelter edit form" do

    expect(find('form')).to have_content('Name')
    expect(find('form')).to have_content('City')
    expect(find('form')).to have_content('Rank')
    expect(find('form')).to have_content('Foster program')
  end

  context "given valid data" do
    it "submits the edit form and updates the shelter" do
      within 'form' do
        fill_in 'shelter_name', with: 'Wichita Shelter'
        fill_in 'shelter_city', with: 'Wichita'
        uncheck 'shelter_foster_program'
        fill_in 'shelter_rank', with: 10
        click_button
      end

      expect(page).to have_current_path('/shelters')
      expect(page).to have_content('Wichita Shelter')
      expect(page).to_not have_content('Houston Shelter')
    end
  end

  context "given invalid data" do
    it 're-renders the edit form' do
      within 'form' do
        fill_in 'shelter_name', with: ''
        fill_in 'shelter_city', with: 'Wichita'
        uncheck 'shelter_foster_program'
        click_button
      end

      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_current_path("/shelters/#{@shelter.id}/edit")
    end
  end
end
