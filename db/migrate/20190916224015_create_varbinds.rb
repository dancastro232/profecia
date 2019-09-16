class CreateVarbinds < ActiveRecord::Migration[5.2]
  def change
    create_table :varbinds do |t|

      t.timestamps
    end
  end
end
