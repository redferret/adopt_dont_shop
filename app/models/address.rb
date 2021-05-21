class Address < ApplicationRecord
  belongs_to :applicant, optional: true
end
