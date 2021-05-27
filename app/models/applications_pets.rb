class ApplicationsPets < ApplicationRecord
  def self.rejected_pet_count_on(application)
    where({status: 'rejected', application_id: application.id}).count
  end

  def self.pending_pet_count_on(application)
    where({status: 'pending', application_id: application.id}).count
  end

  def self.update_all_pet_statuses_on(application, status)
    where(application_id: application.id).update_all(status: status)
  end

  def self.has_rejections_on(application)
    rejected_pet_count_on(application) > 0 || application.already_adopted_count > 0
  end

  def self.no_rejections_on(application)
    rejected_pet_count_on(application) == 0
  end

  def self.no_pending_pets_on(application)
    pending_pet_count_on(application) == 0
  end

  def self.update_status_on(application, pet, status)
    where({application_id: application.id, pet_id: pet.id}).update_all(status: status)
  end
end
