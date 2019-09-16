class AddFieldsToMibs < ActiveRecord::Migration[5.2]
  def change
    add_column :mibs, :oid, :string
    add_column :mibs, :description, :string
  end
end