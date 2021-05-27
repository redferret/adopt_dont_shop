require 'rails_helper'

RSpec.describe Application, type: :model do
  before :each do
    @application = FactoryBot.create(:application)
  end

  after :each do
    Application.destroy_all
  end

  describe 'relationships' do
    it { should have_and_belong_to_many(:pets) }
    it { should have_one(:applicant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:description) }
  end

  describe 'class method,' do
    describe '::all_for_shelter' do
      before :all do
        @shelter = FactoryBot.create(:shelter)
        pet1 = FactoryBot.create(:pet, shelter: @shelter)
        pet2 = FactoryBot.create(:pet, shelter: @shelter)

        @app1 = FactoryBot.create(:application, status: 'Pending')
        @app2 = FactoryBot.create(:application, status: 'Pending')
        @app3 = FactoryBot.create(:application, status: 'Pending')

        @app1.pets << pet1
        @app2.pets << pet2
      end

      after :all do
        @shelter.destroy
        @app1.destroy
        @app2.destroy
        @app3.destroy
      end
      it 'returns all the pending applications for the given shelter id' do
        apps = Application.all_for_shelter(@shelter.id)
        expect(apps).to eq [@app1, @app2]
      end
    end
  end

  describe 'instance method,' do
    describe '#status_badge' do
      before :all do
        @in_progress = "<h4><span class='badge badge-info' role='alert'>In Progress</span></h4>".html_safe
        @pending = "<h4><span class='badge badge-warning' role='alert'>Pending</span></h4>".html_safe
        @accepted = "<h4><span class='badge badge-success' role='alert'>Accepted!</span></h4>".html_safe
        @rejected = "<h4><span class='badge badge-danger' role='alert'>Rejected</span></h4>".html_safe
      end

      it 'returns html with a status badge based on the application status' do
        app = FactoryBot.create(:application)
        app.status = 'In Progress'
        expect(app.status_badge).to eq @in_progress

        app.status = 'Pending'
        expect(app.status_badge).to eq @pending

        app.status = 'Accepted'
        expect(app.status_badge).to eq @accepted

        app.status = 'Rejected'
        expect(app.status_badge).to eq @rejected
      end
    end

    describe '#already_adopted_count' do
      test = 'gets a list of pets on the application that are already adopted on another app'

      before test do
        shelter = FactoryBot.create(:shelter)
        @pet_1 = FactoryBot.create(:pet, shelter: shelter, adoptable:false)
        @pet_2 = FactoryBot.create(:pet, shelter: shelter, adoptable:false)
        @pet_3 = FactoryBot.create(:pet, shelter: shelter)

        @application.pets << @pet_1 << @pet_2 << @pet_3
      end

      after test do
        Shelter.destroy_all
      end

      it test do
        expect(@application.already_adopted_count).to eq 2
      end
    end

    describe '#review_status' do
      it 'sets the status of the application to rejected with rejected or already adopted pets' do
        allow(ApplicationsPets).to receive(:rejected_pet_count_on).and_return(1)
        allow_any_instance_of(Application).to receive(:already_adopted_count).and_return(1)
        allow(ApplicationsPets).to receive(:pending_pet_count_on).and_return(0)

        @application.review_status

        expect(@application.status).to eq 'Rejected'
      end

      it 'sets the status of the application to accepted with no pending or rejected pets' do
        allow(ApplicationsPets).to receive(:rejected_pet_count_on).and_return(0)
        allow_any_instance_of(Application).to receive(:already_adopted_count).and_return(0)
        allow(ApplicationsPets).to receive(:pending_pet_count_on).and_return(0)

        @application.review_status

        expect(@application.status).to eq 'Accepted'
      end
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
end
