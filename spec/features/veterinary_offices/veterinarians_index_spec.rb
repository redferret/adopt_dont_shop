require 'rails_helper'

RSpec.describe 'the veterinary offices veterinarians index' do
  before(:all) do
    @vet_office_1 = FactoryBot.create(:veterinary_office)
    @vet_office_2 = FactoryBot.create(:veterinary_office)
    @not_on_call_vet = FactoryBot.create(:veterinarian, veterinary_office: @vet_office_1, on_call: false, review_rating: 10)

    @vet_1 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office_1, on_call: true, review_rating: 10)
    @vet_2 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office_1, on_call: true, review_rating: 8)
    @vet_3 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office_2, on_call: true, review_rating: 9, name:'Donny')
    @vet_4 = FactoryBot.create(:veterinarian, veterinary_office: @vet_office_2, on_call: true, review_rating: 2, name:'Alex')
  end

  after :all do
    VeterinaryOffice.destroy_all
  end

  it 'lists all the veterinarians associated with the office, with their attributes' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    within "#veterinarian-#{@vet_1.id}" do
      expect(page).to have_content(@vet_1.name)
      expect(page).to have_content(@vet_1.review_rating)
      expect(page).to have_content(@vet_office_1.name)
    end

    within "#veterinarian-#{@vet_2.id}" do
      expect(page).to have_content(@vet_2.name)
      expect(page).to have_content(@vet_2.review_rating)
    end

    expect(page).to_not have_content(@vet_3.name)
  end

  it 'displays a link to edit each veterinarian' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    expect(page).to have_link("Edit #{@vet_1.name}")
    expect(page).to have_link("Edit #{@vet_2.name}")

    click_link("Edit #{@vet_1.name}")
    expect(page).to have_current_path("/veterinarians/#{@vet_1.id}/edit")
  end

  it 'displays a link to delete each veterinarian' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    expect(page).to have_link("Delete #{@vet_1.name}")
    expect(page).to have_link("Delete #{@vet_2.name}")

    click_link("Delete #{@vet_1.name}")

    expect(page).to have_current_path("/veterinarians")
    expect(page).to_not have_content(@vet_1.name)
  end

  it 'displays a link to create a new veterinarian' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    expect(page).to have_link("Create a Veterinarian")
    click_on("Create a Veterinarian")
    expect(page).to have_current_path("/veterinary_offices/#{@vet_office_1.id}/veterinarians/new")
  end

  it 'displays a form for a number value' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    expect(page).to have_content("Only display veterinarians with a review rating of at least...")
    expect(page).to have_select("review_rating")
  end

  it 'only displays records above the given return value' do
    visit "/veterinary_offices/#{@vet_office_1.id}/veterinarians"

    find("#review_rating option[value='5']").select_option
    click_button("Filter")

    expect(page).to have_content(@vet_1.name)
    expect(page).to have_content(@vet_2.name)
    expect(page).to_not have_content(@vet_4.name)
  end

  it 'allows the user to sort veterinarians alphabetically' do
    visit "/veterinary_offices/#{@vet_office_2.id}/veterinarians"

    expect(@vet_3.name).to appear_before(@vet_4.name)

    expect(page).to have_link("Sort alphabetically")
    click_on("Sort alphabetically")

    expect(@vet_4.name).to appear_before(@vet_3.name)
  end
end
