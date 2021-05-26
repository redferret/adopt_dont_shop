require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
  end

  describe 'class methods' do
    describe '::search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '::adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '#status' do
      after :all do
        Application.destroy_all
      end
      it 'returns the status of the pet for the given application id' do
        app = FactoryBot.create(:application)
        app.pets << @pet_2
        @pet_2.update_status_for_application(app.id, 'pending')
        actual_status = @pet_2.status(app.id)

        expect(actual_status).to eq 'pending'
      end
    end

    describe '#not_reviewed' do
      it 'returns true if the status is pending for the pet on the given app id' do
        allow_any_instance_of(Pet).to receive(:status).and_return('pending')
        expect(@pet_3.not_reviewed(0)).to eq true
      end

      it 'returns false if the status is approved for the pet on the given app id' do
        allow_any_instance_of(Pet).to receive(:status).and_return('approved')
        expect(@pet_3.not_reviewed(0)).to eq false
      end
    end

    describe '#update_status_for_application' do
      it 'updates the status of the pet for the given application id and status message' do
        app = FactoryBot.create(:application)
        app.pets << @pet_2
        @pet_2.update_status_for_application(app.id, 'pending')
        actual_status = @pet_2.status(app.id)

        expect(actual_status).to eq 'pending'
      end
    end

    describe '#not_been_approved' do
      it 'returns true if the pet status is not approved' do
        allow_any_instance_of(Pet).to receive(:status).and_return('pending')
        expect(@pet_3.not_been_approved(0)).to eq true
      end

      it 'returns false if the pet status is approved' do
        allow_any_instance_of(Pet).to receive(:status).and_return('approved')
        expect(@pet_3.not_been_approved(0)).to eq false
      end
    end

    describe '#ready_for_review_on' do
      it 'returns true if pet has not been reviewed yet on given application and is adoptable' do
        allow_any_instance_of(Pet).to receive(:not_reviewed).and_return(true)
        app = instance_double(Application, id: 0)

        expect(@pet_2.ready_for_review_on(app)).to eq true
      end

      it 'returns false if pet has not been reviewed yet on given application and is not adoptable' do
        allow_any_instance_of(Pet).to receive(:not_reviewed).and_return(true)
        app = instance_double(Application, id: 0)

        expect(@pet_3.ready_for_review_on(app)).to eq false
      end

      it 'returns false if pet has been reviewed yet on given application whether or not they are adoptable' do
        allow_any_instance_of(Pet).to receive(:not_reviewed).and_return(false)
        app = instance_double(Application, id: 0)

        expect(@pet_3.ready_for_review_on(app)).to eq false
      end
    end

    describe '#reviewed_on_another' do
      it 'returns true if the pet is not reviewed on the given application and is not adoptable' do
        allow_any_instance_of(Pet).to receive(:not_reviewed).and_return(true)
        app = instance_double(Application, id: 0)

        expect(@pet_3.reviewed_on_another(app)).to eq true
      end

      it 'returns true if the pet is not reviewed on the given application and is adoptable' do
        allow_any_instance_of(Pet).to receive(:not_reviewed).and_return(true)
        app = instance_double(Application, id: 0)

        expect(@pet_2.reviewed_on_another(app)).to eq false
      end
    end

    describe '#shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end
end
