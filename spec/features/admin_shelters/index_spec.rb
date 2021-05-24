require 'rails_helper'

RSpec.describe 'The admin shelters index page,' do
  before :all do
    @shelter_1 = FactoryBot.create(:shelter, name: 'Abbies Shelter')
    @shelter_2 = FactoryBot.create(:shelter, name: 'Bobbies Shelter')
    @pet = FactoryBot.create(:pet, shelter: @shelter_1)

    @application = FactoryBot.create(:application)
    FactoryBot.create(:applicant, application: @application)
    @application.pets << @pet
    @application.status = 'Pending'
    @application.save
  end

  before :each do
    visit '/admin/shelters'
  end

  after :all do
    Shelter.destroy_all
  end

  it 'shows all shelters name in reverse alphabetical order' do
    shelter_2 = page.find("#shelter_#{@shelter_2.id}")
    shelter_1 = page.find("#shelter_#{@shelter_1.id}")
    expect(shelter_2).to appear_before(shelter_1)
  end

  it 'shows all shelters with pending applications' do
    within '#shelters_with_pending_apps' do
      expect(page).to have_content(@shelter_1.name)
    end
  end
end
