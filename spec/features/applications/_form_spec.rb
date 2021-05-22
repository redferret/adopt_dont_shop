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
end
