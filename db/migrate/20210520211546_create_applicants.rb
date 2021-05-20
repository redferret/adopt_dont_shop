class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.string :name
      t.belongs_to :application, foreign_key: true

      t.timestamps
    end
  end
end
