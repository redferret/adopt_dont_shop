require 'rails_helper'

RSpec.describe 'The applications index page,' do
  before :all do
    5.times do
      app = FactoryBot.create(:application, status: 'Pending')
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

  it 'has show and delete for each application based on admin or not' do
    Application.all.each do |app|
      within "#app_id_#{app.id}" do
        expect(page).to have_link('Show')
      end

      visit '/admin/applications'

      within "#app_id_#{app.id}" do
        expect(page).to have_link('Show')
        expect(page).to have_link('Destroy', href: "/admin/applications/#{app.id}")
      end
    end
  end

  describe 'button,' do
    describe 'show,' do
      it 'navigates to the show page' do
        app = Application.first
        within "#app_id_#{app.id}" do
          click_link 'Show'
          current_path.should eq application_path(app.id)
        end
      end
    end

    describe 'delete,' do
      it 'navigates to the index page' do
        visit '/admin/applications'
        app = Application.first
        within "#app_id_#{app.id}" do
          click_link 'Destroy'
          current_path.should eq '/admin/applications'
        end
      end
    end
  end

end
