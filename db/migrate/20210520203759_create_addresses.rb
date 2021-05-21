class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.numeric :zipcode
      t.bigint :applicant_id

      t.timestamps
    end

    add_index :addresses, :applicant_id
  end
end
