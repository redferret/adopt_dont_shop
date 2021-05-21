class CreateApplicaionsPetsJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :applications, :pets do |t|
      t.index :application_id
      t.index :pet_id
    end
  end
end
