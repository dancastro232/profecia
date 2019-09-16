class AddFieldsToVarbinds < ActiveRecord::Migration[5.2]
  def change
    add_column :varbinds, :mib_id, :integer
  end
end
