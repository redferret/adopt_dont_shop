require 'rails_helper'

RSpec.describe Application, type: :model do
  before :each do
    @application = FactoryBot.create(:application)
  end

  after :each do
    Application.destroy_all
  end

  describe '#not_new' do
    it 'returns false if there is an applicant' do
      expect(@application.not_new).to eq false
    end

    it 'returns true if there is an applicant' do
      FactoryBot.create(:applicant, application: @application)
      expect(@application.not_new).to eq true
    end
  end

  describe '#can_not_edit_description' do
    it 'returns true if the applicant needs to select pets and app is new' do
      @application.status = 'In Progress'
      expect(@application.can_not_edit_description).to eq true
    end

    it' returns true if the application is pending, pets are selected and app is not new' do
      FactoryBot.create(:applicant, application: @application)
      pet = FactoryBot.create(:pet, shelter: FactoryBot.create(:shelter))

      @application.pets << pet
      @application.description = Faker::Lorem.sentence
      @application.status = 'Pending'

      expect(@application.can_not_edit_description).to eq true
    end

    it 'returns false if the applicant has pets selected and status is in progress' do
      FactoryBot.create(:applicant, application: @application)
      pet = FactoryBot.create(:pet, shelter: FactoryBot.create(:shelter))

      @application.pets << pet
      @application.status = 'In Progress'

      expect(@application.can_not_edit_description).to eq false
    end

    it 'returns true if the applicant has no pets selected and status is in progress' do
      FactoryBot.create(:applicant, application: @application)

      @application.status = 'In Progress'

      expect(@application.can_not_edit_description).to eq true
    end
  end
end
