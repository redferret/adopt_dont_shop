require 'rails_helper'

RSpec.describe 'The partial form for applications,', type: :view do
  describe 'fields,' do
    before :all do
      @application = FactoryBot.create(:application)
      @applicant = FactoryBot.create(:applicant, application: @application)
      FactoryBot.create(:address, applicant: @applicant)
    end

    before :each do
      render partial: 'applications/form', locals: {
        application: @application,
        applicant: @applicant
      }
    end

    after :all do
      Application.destroy_all
    end

    it 'has an input for an applicants name' do
      within '#applications_form' do
        expect(page).to have_content("Applicant's Name")
        expect(page).to have_field('applicant[name]')
      end
    end

    it 'has inputs for the applicants address' do
      within '#applications_form' do
        expect(page).to have_content('Street:')
        expect(page).to have_field('address[street]')

        expect(page).to have_content('City:')
        expect(page).to have_field('address[city]')

        expect(page).to have_content('State:')
        expect(page).to have_field('address[state]')

        expect(page).to have_content('Zipcode:')
        expect(page).to have_field('address[zipcode]')
      end
    end

    it 'has a description box' do
      within '#applications_form' do
        expect(page).to have_content('Descriptive reason why to adopt:')
        expect(page).to have_field('application[description]')
      end
    end

    it 'has a submit button' do
      within '#applications_form' do
        expect(page).to have_selector("input", type: 'submit')
      end
    end
  end

 # Move this test to the edit_spec file
  xit 'submit button navigates to the show page of the updated application' do
    new_name = Fake::Name.name
    new_street_name = Faker::Address.street

    within '#applications_form' do
      fill_in 'applicant[name]', with: new_name
      fill_in 'address[street]', with: new_street_name
      fill_in 'address[state]', with: Fake::Addresss.state_abbr
      fill_in 'address[city]', with: Fake::Addresss.city
      fill_in 'address[zipcode]', with: Faker::Address.zip
      fill_in 'application[description]', with: 'I have the best home for these babies!'
      click_button
    end

    new_application = Application.last.order(:id, :asc).limit(1)

    current_path.should eq "/applications/#{new_application.id}"
  end
end
