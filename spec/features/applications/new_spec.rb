require 'rails_helper'

RSpec.describe 'The new application page,' do
  before :each do
    visit new_application_path
  end

  after :each do
    Application.destroy_all
  end

  it 'has the partial form for an application' do
    expect(page).to have_selector('#applications_form')
  end

  describe 'submit button,' do
    it 'navigates to the show page of the new application with valid input' do
      new_name = Faker::Name.name
      new_street_name = Faker::Address.street_name

      within 'form' do
        fill_in 'applicant[name]', with: new_name
        fill_in 'address[street]', with: new_street_name
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
        click_button
      end

      new_application = Application.first

      current_path.should eq application_path(new_application.id)

      expect(page).to have_content(new_name)
      expect(page).to have_content(new_street_name)
    end

    it 'navigates back to the new page with errors on the address model' do
      within 'form' do
        fill_in 'applicant[name]', with: Faker::Name.name
        fill_in 'address[street]', with: ''
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
        click_button
      end

      current_path.should eq applications_path
      expect(page).to have_content("Error: Street can't be blank")
    end

    it 'navigates back to the new page with errors on the applicant model' do
      within 'form' do
        fill_in 'applicant[name]', with: ''
        fill_in 'address[street]', with: Faker::Address.street_name
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
        click_button
      end

      current_path.should eq applications_path
      # Come back here!
      expect(page).to have_content("Error: Applicant must exist")
    end
  end
end
