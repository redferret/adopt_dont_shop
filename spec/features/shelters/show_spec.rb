require 'rails_helper'

RSpec.describe 'the shelter show' do
  before :all do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: true, rank: 9)
    @shelter.pets.create(name: 'garfield', breed: 'shorthair', adoptable: true, age: 1)
  end

  before :each do
    visit "/shelters/#{@shelter.id}"
  end

  after :all do
    Shelter.destroy_all
  end

  it "shows the shelter and all it's attributes" do
    expect(page).to have_content(@shelter.name)
    expect(page).to have_content(@shelter.rank)
    expect(page).to have_content(@shelter.city)
  end

  it "shows the number of pets associated with the shelter" do
    within "#pet-count" do
      expect(page).to have_content(@shelter.pets.count)
    end
  end

  it "allows the user to delete a shelter" do
    click_on("Delete")

    expect(page).to have_current_path('/shelters')
    expect(page).to_not have_content(@shelter.name)
  end

  it 'displays a link to the shelters pets index' do
    expect(page).to have_link("Show Pets")
    click_link("Show Pets")

    expect(page).to have_current_path("/shelters/#{@shelter.id}/pets")
  end
end
