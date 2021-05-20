class Application < ApplicationRecord
  has_one :applicant, dependent: :destroy
  has_many :pets

  validates_associated :applicant
  
  validates :description, presence: true
  validates :status, presence: true
end
