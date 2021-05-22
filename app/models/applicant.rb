class Applicant < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_one :address, dependent: :destroy
  belongs_to :application
  validates :name, presence: true


  def set_defaults
    self.name ||= ''
    self.address ||= Address.new
  end
end
