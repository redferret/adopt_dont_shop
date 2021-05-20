class Applicant < ApplicationRecord
  has_one :address, dependent: :destroy
  belongs_to :application, foreign_key: true

  validates_associated :address
end
