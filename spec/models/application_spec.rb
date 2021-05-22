require 'rails_helper'

RSpec.describe Application, type: :model do
  before :all do
    @application = FactoryBot.create(:application)
  end

  after :each do
    Applicant.destroy_all
  end

  after :all do
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
    it 'returns true if the applicant needs to select pets or app is new or status is pending' do
      
    end

    it 'returns false if the applicant has pets selected and status is not pending'
  end
end
