require 'rails_helper'

RSpec.describe 'The applications index page,' do
  before :all do
    5.times do
      app = FactoryBot.create(:application)
      applicant = FactoryBot.create(:applicant, application: app)
      FactoryBot.create(:address, applicant: applicant)
    end
  end

  before :each do
    visit applications_path
  end

  after :all do
    Application.destroy_all
  end

  it 'shows all the applications' do
    Application.all.each do |app|
      within "#app_id_#{app.id}" do
        expect(page).to have_content(app.description)
        expect(page).to have_content(app.status)
      end
    end
  end

  it 'has show edit and delete for each application' do
    Application.all.each do |app|
      within "#app_btns_id_#{app.id}" do
        expect(page).to have_link('Show')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Destroy')
      end
    end
  end

  describe 'button,' do
    describe 'show,' do
      it 'navigates to the show page' do
        app = Application.first
        within "#app_btns_id_#{app.id}" do
          click_link 'Show'
          current_path.should eq application_path(app.id)
        end
      end
    end
    describe 'edit,' do
      it 'navigates to the edit page' do
        app = Application.first
        within "#app_btns_id_#{app.id}" do
          click_link 'Edit'
          current_path.should eq edit_application_path(app)
        end
      end
    end
    describe 'delete,' do
      it 'navigates to the index page' do
        app = Application.first
        within "#app_btns_id_#{app.id}" do
          click_link 'Destroy'
          current_path.should eq applications_path
        end
      end
    end
  end

end
