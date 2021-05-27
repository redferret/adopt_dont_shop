require 'rails_helper'

RSpec.describe ApplicationsPets do
  describe '#pending_pet_count_on' do
    test = 'gets a list of pets on the application where the pet status is pending'

    before test do
      @application = FactoryBot.create(:application)
      shelter = FactoryBot.create(:shelter)
      pet_1 = FactoryBot.create(:pet, shelter: shelter)
      pet_2 = FactoryBot.create(:pet, shelter: shelter)
      pet_3 = FactoryBot.create(:pet, shelter: shelter)

      @application.pets << pet_1 << pet_2 << pet_3
      ApplicationsPets.update_status_on(@application, pet_1, 'pending')
      ApplicationsPets.update_status_on(@application, pet_2, 'pending')
    end

    after test do
      Shelter.destroy_all
      @application.destroy
    end

    it test do
      expect(ApplicationsPets.pending_pet_count_on(@application)).to eq 2
    end
  end

  describe '#update_all_pet_statuses_on' do
    after :all do
      Shelter.destroy_all
      Application.destroy_all
    end
    it 'updates all the statuses of each pet to the given status' do
      application = FactoryBot.create(:application)
      shelter = FactoryBot.create(:shelter)
      pet_1 = FactoryBot.create(:pet, shelter: shelter)
      pet_2 = FactoryBot.create(:pet, shelter: shelter)
      pet_3 = FactoryBot.create(:pet, shelter: shelter)

      application.pets << pet_1 << pet_2 << pet_3

      ApplicationsPets.update_all_pet_statuses_on(application, 'rejected')
      actual_result = ApplicationsPets.where({application_id: application.id, status: 'rejected'})

      expect(actual_result.map(&:status)).to eq ['rejected', 'rejected', 'rejected']
    end
  end

  describe '#update_status_on' do
    after :all do
      Shelter.destroy_all
      Application.destroy_all
    end
    it 'updates the status of the pet for the given application id and status message' do
      app = FactoryBot.create(:application)
      shelter = FactoryBot.create(:shelter)
      pet = FactoryBot.create(:pet, shelter: shelter)

      app.pets << pet
      ApplicationsPets.update_status_on(app, pet, 'pending')
      actual_status = pet.status(app.id)

      expect(actual_status).to eq 'pending'
    end
  end

  describe '#rejected_pet_count_on' do
    test = 'gets a list of pets on the application where the pet status is rejected'

    before test do
      @application = FactoryBot.create(:application, status: 'In Progress')
      shelter = FactoryBot.create(:shelter)
      pet_1 = FactoryBot.create(:pet, shelter: shelter)
      pet_2 = FactoryBot.create(:pet, shelter: shelter)
      pet_3 = FactoryBot.create(:pet, shelter: shelter)

      @application.pets << pet_1 << pet_2 << pet_3
      ApplicationsPets.update_status_on(@application, pet_1, 'rejected')
      ApplicationsPets.update_status_on(@application, pet_2, 'rejected')
    end

    after test do
      Shelter.destroy_all
      @application.destroy
    end

    it test do
      expect(ApplicationsPets.rejected_pet_count_on(@application)).to eq 2
    end
  end
end
