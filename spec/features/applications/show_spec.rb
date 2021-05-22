require 'rails_helper'

RSpec.describe 'The applications show page,' do

  before :all do
    @application = FactoryBot.create(:application)
    @applicant = FactoryBot.create(:applicant, application: @application)
    @address = FactoryBot.create(:address, applicant: @applicant)

    shelter = FactoryBot.create(:shelter)
    @pet_1 = FactoryBot.create(:pet, shelter: shelter, name: 'Spot')
    @pet_2 = FactoryBot.create(:pet, shelter: shelter, name: 'Spinner')
    @pet_3 = FactoryBot.create(:pet, shelter: shelter, name: 'Buddy')
    @pet_4 = FactoryBot.create(:pet, shelter: shelter, name: 'Lucky')
    @pet_5 = FactoryBot.create(:pet, shelter: shelter, name: 'Dash')
  end

  after :all do
    Application.destroy_all
    Shelter.destroy_all
  end

  describe 'content,' do
    before :all do
      @application.pets << Pet.all
    end

    before :each do
      visit application_path(@application.id)
    end

    it 'shows applicants name' do
      expect(page).to have_content(@applicant.name)
    end

    it 'shows the applicants address' do
      expect(page).to have_content(@address.street)
      expect(page).to have_content(@address.city)
      expect(page).to have_content(@address.state)
      expect(page).to have_content(@address.zipcode)
    end

    it 'shows a description'do
      expect(page).to have_content('Why I would make a good home:')
      expect(page).to have_content(@application.description)
    end

    it 'lists all pets on the application' do
      expect(page).to have_link(@pet_1.name)
      expect(page).to have_link(@pet_2.name)
      expect(page).to have_link(@pet_3.name)
    end

    it 'shows the status of the application' do
      expect(page).to have_content(@application.status)
    end

    describe 'clickable link,' do
      describe 'view pet link' do
        it 'navigates to pet show page' do
          page.find("#view_pet_#{@pet_1.id}").click
          current_path.should eq "/pets/#{@pet_1.id}"
        end
      end

      describe 'Edit application' do
        it 'navigates to the edit page for application' do
          page.find('#edit_application').click
          current_path.should eq edit_application_path(@application)
        end
      end

      describe 'Back' do
        it 'goes back to the application index' do
          page.find('#back_to_index').click
          current_path.should eq applications_path
        end
      end
    end
  end

  describe 'searching and adding pets,' do
    before :all do
    end

    before :each do
      visit application_path(@application.id)
    end

    it 'allows a user to search for pets if that app is in progress'

    it 'user sees a list of pets after submitting a search by'

  end

end
