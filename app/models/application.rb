class Application < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_one :applicant, dependent: :destroy
  has_and_belongs_to_many :pets

  validates :status, presence: true

  def set_defaults
    self.description ||= ''
    self.status ||= 'New'
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
