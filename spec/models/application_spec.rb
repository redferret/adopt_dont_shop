require 'rails_helper'

RSpec.describe Application, type: :model do
  before :each do
    @application = FactoryBot.create(:application)
  end

  after :each do
    Application.destroy_all
  end

  describe '#is_new?' do
    it 'returns false if there is an applicant and status is not new' do
      FactoryBot.create(:applicant, application: @application)
      @application.status = 'In Progress'
      expect(@application.is_new?).to eq false
    end

    it 'returns true if there is no applicant and status is new' do
      @application.status = 'New'
      expect(@application.is_new?).to eq true
    end
  end

  describe '#set_defaults' do
    it 'sets the defaults of a new application not yet persisted' do
      application = Application.new
      expect(application.status).to eq 'New'
      expect(application.description).to eq ''
    end
  end

  describe '#in_progress?' do
    it 'returns true if there is an applicant and status is in progress' do
      @application.status = 'In Progress'
      FactoryBot.create(:applicant, application: @application)
      expect(@application.in_progress?).to eq true
    end

    it 'returns false if the application is new' do
      application = Application.new
      expect(application.in_progress?).to eq false
    end
  end

  describe '#pending?' do
    it 'returns true if the status is pending' do
      application = Application.new
      application.status = 'Pending'
      expect(application.pending?).to eq true
    end

    it 'returns false if the status is not pending' do
      expect(@application.pending?).to eq false
    end
  end

  describe '#ready_to_submit?' do
    it 'returns true if the application has an applicant, status is in progress and there are pets' do
      FactoryBot.create(:applicant, application: @application)
      pet = FactoryBot.create(:pet, shelter: FactoryBot.create(:shelter))

      @application.pets << pet
      @application.description = Faker::Lorem.sentence
      @application.status = 'In Progress'

      expect(@application.ready_to_submit?).to eq true
    end
  end

  describe '#can_not_edit_description' do
    it 'returns true if the applicant needs to select pets and app is new' do
      @application.status = 'In Progress'
      expect(@application.can_not_edit_description).to eq true
    end

    it 'returns true if the application is pending, pets are selected and app is not new' do
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
