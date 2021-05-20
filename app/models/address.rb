class Address < ApplicationRecord
  belongs_to :applicant, optional: true, foreign_key: true
end
