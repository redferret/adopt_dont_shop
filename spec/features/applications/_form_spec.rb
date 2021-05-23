require 'rails_helper'

RSpec.describe 'The partial form for applications,', type: :view do

  after :all do
    Application.destroy_all
    Shelter.destroy_all
  end

  describe 'as a new application,' do
    before :all do
      @application = FactoryBot.create(:application)
    end

    before :each do
      render partial: 'applications/form', locals: {
        application: @application,
        applicant: Applicant.new
      }
    end

    it 'has a field to enter a name' do
      within '#applications_form' do
        expect(page).to have_content("Applicant's Name")
        expect(page).to have_field('applicant[name]')
      end
    end

    it 'has an address form' do
      within '#applications_form' do
        expect(page).to have_selector('#address_form')

        within '#address_form' do
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
    end

    it 'shows a sumbit button to create application' do
      within '#applications_form' do
        expect(page).to have_selector('input', with: 'Create Application')
      end
    end
  end

  describe 'when application is in progress,' do
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

    it 'shows the applicant name' do
      within '#applications_form' do
        expect(page).to have_content(@applicant.name)
      end
    end

    it 'shows the address for the applicant' do
      within '#applications_form' do
        expect(page).to have_selector('#address_description')
      end
    end

    it 'shows a submit button if there are pets on the application' do
      within '#applications_form' do
        expect(page).to have_selector('input', with: 'Create Application')
      end
    end

    describe 'describe text area,' do
      it 'is disabled if there are no pets to adopt yet' do
        application = FactoryBot.create(:application)
        applicant = FactoryBot.create(:applicant, application: application)
        FactoryBot.create(:address, applicant: applicant)

        shelter = FactoryBot.create(:shelter)
        pet = FactoryBot.create(:pet, shelter: shelter)

        application.pets << pet
        application.status = 'In Progress'

        render partial: 'applications/form', locals: {
          application: application,
          applicant: applicant
        }

        within '#applications_form' do
          expect(page).to have_content('Why I would make a good home:')
          expect(page).to have_field('application[description]', disabled: true)
        end
      end

      it 'is enabled if there are 1 or more pets to adopt' do
        within '#applications_form' do
          expect(page).to have_content('Why I would make a good home:')
          expect(page).to have_field('application[description]', disabled: false)
        end
      end
    end
  end
end
