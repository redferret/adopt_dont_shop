require 'rails_helper'

RSpec.describe 'The applications show page,' do
  before :all do
    @app_1 = FactoryBot.create(:application)
    @applicant = FactoryBot.create(:applicant, application: @app_1)

    shelter = FactoryBot.create(:shelter)
    @pet_1 = FactoryBot.create(:pet, shelter: shelter)
    @pet_2 = FactoryBot.create(:pet, shelter: shelter)
    @pet_3 = FactoryBot.create(:pet, shelter: shelter)

    @app_1.pets << Pet.all
  end

  before :each do
    visit "/applications/#{@app_1.id}"
  end

  after :all do
    Application.destroy_all
    Shelter.destroy_all
  end

  it 'shows applicants name'

  it 'shows the applicants address'

  it 'shows a description'

  it 'lists all pets on the application'

  it 'shows the status of the application'
end
