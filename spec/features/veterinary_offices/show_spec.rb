  require 'rails_helper'

RSpec.describe 'the vet office show' do
  before :all do
    @vet_office = FactoryBot.create(:veterinary_office)
  end

  before :each do
    visit "/veterinary_offices/#{@vet_office.id}"
  end

  after :all do
    VeterinaryOffice.destroy_all
  end

  it "shows the vet office and all it's attributes" do
    expect(page).to have_content(@vet_office.name)
    expect(page).to have_content(@vet_office.max_patient_capacity)
  end

  it "shows the number of veterinarians associated with the vet office" do
    within ".veterinarian-count" do
      expect(page).to have_content(@vet_office.veterinarians.count)
    end
  end

  it "allows the user to delete a vet office" do
    click_on("Delete #{@vet_office.name}")

    expect(page).to have_current_path('/veterinary_offices')
    expect(page).to_not have_content(@vet_office.name)
  end

  it "displays a link to the veterinary offices's veterinarians" do
    expect(page).to have_link("All veterinarians at #{@vet_office.name}")
    click_link("All veterinarians at #{@vet_office.name}")

    expect(page).to have_current_path("/veterinary_offices/#{@vet_office.id}/veterinarians")
  end
end
