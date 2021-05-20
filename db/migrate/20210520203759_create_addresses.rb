class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.numeric :zipcode
      t.belongs_to :applicant, foreign_key: true

      t.timestamps
    end
  end
end
