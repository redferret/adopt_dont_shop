class Applicant < ApplicationRecord
  has_one :address, dependent: :destroy
  belongs_to :application

  validates_associated :address
end
