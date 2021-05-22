require 'rails_helper'

RSpec.describe Applicant, type: :model do
  describe '#set_defaults' do
    it 'sets the default values for this model if new is called' do
      applicant = Applicant.new
      expect(applicant.name).to eq ''
      expect(applicant.address).to_not eq nil
    end
  end
end
