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
      within '#applications_form' do
        fill_in 'applicant[name]', with: Faker::Name.name
      end
      within '#address_form' do
        fill_in 'address[street]', with: Faker::Address.street_name
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
      end

      within '#applications_form' do
        click_button 'Create Application'
      end

      new_application = Application.first

      current_path.should eq applications_path

      new_applicant = new_application.applicant
      new_address = new_applicant.address

      expect(page).to have_content(new_applicant.name)

      within '#address_description' do
        expect(page).to have_content(new_address.street)
        expect(page).to have_content(new_address.state)
        expect(page).to have_content(new_address.city)
        expect(page).to have_content(new_address.zipcode)
      end
    end

    it 'navigates back to the new page with errors on the address model' do
      within '#applications_form' do
        fill_in 'applicant[name]', with: Faker::Name.name
      end
      within '#address_form' do
        fill_in 'address[street]', with: ''
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
      end

      within '#applications_form' do
        click_button 'Create Application'
      end

      current_path.should eq applications_path
      expect(page).to have_content("Error: Street can't be blank")
    end

    it 'navigates back to the new page with errors on the applicant model' do
      within '#applications_form' do
        fill_in 'applicant[name]', with: ''
      end
      within '#address_form' do
        fill_in 'address[street]', with: Faker::Address.street_name
        fill_in 'address[state]', with: Faker::Address.state_abbr
        fill_in 'address[city]', with: Faker::Address.city
        fill_in 'address[zipcode]', with: Faker::Address.zip
      end

      within '#applications_form' do
        click_button 'Create Application'
      end

      current_path.should eq applications_path
      expect(page).to have_content("Error: Applicant must exist")
    end
  end
end
