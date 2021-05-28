class Address < ApplicationRecord
  belongs_to :applicant

  validates :street, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
end
