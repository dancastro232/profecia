class CreateMibs < ActiveRecord::Migration[5.2]
  def change
    create_table :mibs do |t|

      t.timestamps
    end
  end
end
