class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.string :name
      t.bigint :application_id
      t.timestamps
    end

    add_index :applicants, :application_id
  end
end
