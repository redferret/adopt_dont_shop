class Applicant < ApplicationRecord
  has_one :address, dependent: :destroy
  belongs_to :application

  validates :name, presence: true
end
