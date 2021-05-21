class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  belongs_to :application, optional: true, foreign_key: true

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end
end
