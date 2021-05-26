class Application < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_one :applicant, dependent: :destroy

  has_and_belongs_to_many :pets

  validates :status, presence: true
  validates :description, presence: true

  def set_defaults
    self.description ||= ''
    self.status ||= 'New'
  end

  def rejected_pet_count
    ApplicationsPets.where({status: 'rejected', application_id: id}).count
  end

  def pending_pet_count
    ApplicationsPets.where({status: 'pending', application_id: id}).count
  end

  def already_adopted_count
    pets.where(adoptable:false).count
  end

  def update_all_pet_statuses(status)
    ApplicationsPets.where(application_id: id).update_all(status: status)
  end

  def review_status
    has_rejections = rejected_pet_count > 0 || already_adopted_count > 0
    no_rejections = rejected_pet_count == 0
    no_pending_pets = pending_pet_count == 0

    if has_rejections
      self.status = 'Rejected'
      update_all_pet_statuses('waiting')
    elsif no_rejections && no_pending_pets
      self.status = 'Accepted'
      pets.update_all(adoptable: false)
    end

  end

  def status_badge
    case status
    when 'In Progress'
      "<h4><span class='badge badge-info' role='alert'>In Progress</span></h4>".html_safe
    when 'Pending'
      "<h4><span class='badge badge-warning' role='alert'>Pending</span></h4>".html_safe
    when 'Accepted'
      "<h4><span class='badge badge-success' role='alert'>Accepted!</span></h4>".html_safe
    when 'Rejected'
      "<h4><span class='badge badge-danger' role='alert'>Rejected</span></h4>".html_safe
    end
  end

  def is_new?
    applicant.nil? && status == 'New'
  end

  def in_progress?
    (not applicant.nil?) && (status == 'In Progress')
  end

  def pending?
    status == 'Pending'
  end

  def self.all_for_shelter(shelter_id)
    Application.where(status: 'Pending').joins(:pets).where({pets: {shelter_id: shelter_id}}).group(:id)
  end

  def can_not_edit_description
    return true if (applicant.nil? && pets.empty? && (status == 'New' || status == 'In Progress'))
    return true if (!applicant.nil? && !pets.empty? && status == 'Pending')
    return true if (!applicant.nil? && pets.empty? && status == 'In Progress')
    return false if (!applicant.nil? && !pets.empty? && status == 'In Progress')
  end

  def ready_to_submit?
    (not applicant.nil?) && (status == 'In Progress') && (not pets.empty?)
  end
end
