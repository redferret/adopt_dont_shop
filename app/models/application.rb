class Application < ApplicationRecord
  has_one :applicant, dependent: :destroy
  has_and_belongs_to_many :pets

  validates :description, presence: true
  validates :status, presence: true
end
