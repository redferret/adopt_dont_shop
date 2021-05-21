require 'rails_helper'

RSpec.describe 'the veterinarians index' do

  before :all do
    @vet_office = FactoryBot.create(:veterinary_office)
    @vet_1 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office)
    @vet_2 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office)
  end

  before :each do
    visit '/veterinarians'
  end

  it 'lists all the veterinarians with their attributes' do
    expect(page).to have_content(@vet_1.name)
    expect(page).to have_content(@vet_1.review_rating)
    expect(page).to have_content(@vet_office.name)

    expect(page).to have_content(@vet_2.name)
    expect(page).to have_content(@vet_2.review_rating)
    expect(page).to have_content(@vet_office.name)
  end

  it 'only shows on call veterinarians' do
    expect(page).to_not have_content(@vet_1.name)
  end

  it 'displays a link to edit each veterinarian' do
    expect(page).to have_link("Edit #{@vet_1.name}")
    expect(page).to have_link("Edit #{@vet_2.name}")

    click_link("#delete_vet_#{@vet_1.id}")

    expect(page).to have_current_path("/veterinarians/#{@vet_1.id}/edit")
  end

  it 'displays a link to delete each veterinarian' do
    expect(page).to have_link("Delete #{@vet_1.name}")
    expect(page).to have_link("Delete #{@vet_2.name}")

    click_link("#delete_vet_#{@vet_2.id}")

    expect(page).to have_current_path("/veterinarians")
    expect(page).to_not have_content(@vet_1.name)
  end
end
