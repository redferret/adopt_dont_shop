require 'rails_helper'

RSpec.describe Address do
  describe 'relationships' do
    it { should belong_to(:applicant) }
  end

  describe 'validations' do
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zipcode) }
    it { should validate_numericality_of(:zipcode) }
  end
end
