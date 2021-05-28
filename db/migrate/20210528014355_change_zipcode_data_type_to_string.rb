class ChangeZipcodeDataTypeToString < ActiveRecord::Migration[5.2]
  def up
    change_column :addresses, :zipcode, :string
  end

  def down
    change_column :addresses, :zipcode, :integer
  end
end
