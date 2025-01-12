class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true

  has_and_belongs_to_many :applications

  belongs_to :shelter

  def shelter_name
    shelter.name
  end

  def status(application_id)
    ApplicationsPets.where({application_id: application_id, pet_id: id}).first.status
  end

  def not_reviewed(application_id)
    status(application_id) == 'pending'
  end

  def self.search_adoptable_pet(search_pet_by)
    search(search_pet_by).where(adoptable: true)
  end

  def not_been_approved(application_id)
    status(application_id) != 'approved'
  end

  def ready_for_review_on(application)
    not_reviewed(application.id) && adoptable
  end

  def reviewed_on_another(application)
    not_reviewed(application.id) && !adoptable
  end

  def self.adoptable
    where(adoptable: true)
  end
end
