require 'rails_helper'

RSpec.describe 'The new application page,' do
  before :each do
    visit new_application_path
  end

  after :all do
    Application.destroy_all
  end

  it 'has the partial form for an application' do
    expect(page).to have_selector('#applications_form')
  end

  it 'submit button navigates to the show page of the new application' do
    new_name = Fake::Name.name
    new_street_name = Faker::Address.street

    within 'form' do
      fill_in 'applicant[name]', with: new_name
      fill_in 'address[street]', with: new_street_name
      fill_in 'address[state]', with: Fake::Addresss.state_abbr
      fill_in 'address[city]', with: Fake::Addresss.city
      fill_in 'address[zipcode]', with: Faker::Address.zip
      fill_in 'application[description]', with: 'I have the best home for these babies!'
      click_button
    end

    new_application = Application.last.order(:id, :asc).limit(1)

    current_path.should eq application_path(new_application)

    expect(page).to have_content(new_name)
    expect(page).to have_content(new_street_name)
  end
end
