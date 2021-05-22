class Application < ApplicationRecord
  has_one :applicant, dependent: :destroy
  has_and_belongs_to_many :pets

  validates :description, presence: true
  validates :status, presence: true

  def not_new
    not applicant.nil?
  end

  def can_not_edit_description
    return true if (applicant.nil? && pets.empty? && (status.nil? || status == 'In Progress'))
    return true if (!applicant.nil? && !pets.empty? && status == 'Pending')
    return true if (!applicant.nil? && pets.empty? && status == 'In Progress')
    return false if (!applicant.nil? && !pets.empty? && status == 'In Progress')
  end
end
