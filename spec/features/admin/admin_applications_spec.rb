require 'rails_helper'

RSpec.describe 'Admin view on application,' do
  before :each do
    @app = FactoryBot.create(:application, status: 'Pending')
    applicant = FactoryBot.create(:applicant, application: @app)
    FactoryBot.create(:address, applicant: applicant)

    shelter = FactoryBot.create(:shelter)
    @pet = FactoryBot.create(:pet, shelter: shelter)

    @app.pets << @pet
    ApplicationsPets.update_status_on(@app, @pet, 'pending')

    visit "/admin/applications/#{@app.id}"
  end

  after :all do
    Application.destroy_all
    Shelter.destroy_all
  end

  describe 'approve/reject buttons,' do
    describe 'approve pet,' do
      it 'is next to each pet that needs to be reviewed' do
        within '#pets_on_application' do
          expect(page).to have_link('Approve')
        end
      end

      it 'shows that the pet is approved after clicking approve' do
        within '#pets_on_application' do
          click_link 'Approve'
        end
        current_path.should eq "/admin/applications/#{@app.id}"
        within '#pets_on_application' do
          expect(page).to have_content('Approved!')
        end
      end
    end

    describe 'rejecting pet,' do
      it 'is next to each pet that needs to be reviewed' do
        within '#pets_on_application' do
          expect(page).to have_link('Reject')
        end
      end

      it 'shows that the pet is rejected after clicking reject' do
        within '#pets_on_application' do
          click_link 'Reject'
        end
        current_path.should eq "/admin/applications/#{@app.id}"

        within '#pets_on_application' do
          expect(page).to have_content('Rejected')
        end
      end
    end
  end
end
