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
      @application.pets << @pet_1 << @pet_2 << @pet_3
    end

    before :each do
      visit application_path(@application.id)
    end

    after :all do
      @application.pets.clear
    end

    it 'shows applicants name' do
      expect(page).to have_content(@applicant.name)
    end

    it 'shows the applicants address' do
      within '#address_section' do
        expect(page).to have_field('address[street]', with: @address.street)
        expect(page).to have_field('address[city]', with: @address.city)
        expect(page).to have_field('address[state]', with: @address.state)
        expect(page).to have_field('address[zipcode]', with: @address.zipcode)
      end
    end

    it 'shows a description if application is in progress' do
      within '#applications_form' do
        expect(page).to have_content('Why I would make a good home:')
        expect(page).to have_content(@application.description)
      end
    end

    it 'lists all pets added to the application' do
      within '#search_for_pet_section' do
        expect(page).to have_link(@pet_1.name)
        expect(page).to have_link(@pet_2.name)
        expect(page).to have_link(@pet_3.name)
      end
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

      describe 'Back' do
        it 'goes back to the application index' do
          page.find('#back_to_index').click
          current_path.should eq applications_path
        end
      end
    end
  end

  describe 'adding pet,' do
    before :each do
      visit application_path(@application.id)
    end

    it 'has a button next to each found pet' do
      within '#search_pet_form' do
        fill_in 'application[search_pet_by]', with: 'Spot'
        click_button
      end

      within '#pets_found_by' do
        expect(page).to have_content(@pet_1.name)
      end
    end

    describe 'adopt pet button,' do
      it 'adds the pet to the application' do
        within '#search_pet_form' do
          fill_in 'application[search_pet_by]', with: @pet_1.name
          click_button
        end

        within "#pets_found_by" do
          click_button
        end

        current_path.should eq application_path(@application.id)

        within '#pets_on_application' do
          expect(page).to have_link(@pet_1.name)
        end
      end
    end
  end

  describe 'search pet,' do
    before :each do
      visit application_path(@application.id)
    end

    it 'has a form to search pets with text field and a submit button' do
      within '#search_pet_form' do
        expect(page).to have_field('application[search_pet_by]', with: '')
      end
    end

    it 'allows a user to search for pets if the app is in progress' do
      within '#search_for_pet_section' do
        expect(page).to have_content('Add a Pet to this Application')
      end
    end

    it 'lets the user see a list of pets after submitting a search' do
      within '#search_pet_form' do
        fill_in 'application[search_pet_by]', with: 's'
        click_button
      end

      current_path.should eq application_path(@application.id)

      within '#pets_found_by' do
        expect(page).to have_content('Spot')
        expect(page).to have_content('Spinner')
      end
    end
  end
end
