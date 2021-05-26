class CreateApplicationsPets < ActiveRecord::Migration[5.2]
  def change
    create_join_table :applications, :pets do |t|
      t.index :application_id
      t.index :pet_id

      t.string :status, default: 'waiting'
    end
  end
end
