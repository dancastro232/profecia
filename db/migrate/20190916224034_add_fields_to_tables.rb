class AddFieldsToTables < ActiveRecord::Migration[5.2]
  def change
    add_column :agents, :ip_address, :string
    add_column :agents, :port, :integer
    add_column :agents, :version, :integer

    add_column :metrics, :community, :string
    add_column :metrics, :error_status, :integer
    add_column :metrics, :error_index, :integer
    add_column :metrics, :type, :integer
    add_column :metrics, :request_id, :string
    add_column :metrics, :varbind_id, :integer
    add_column :metrics, :agent_id, :integer

    add_column :varbinds, :value, :string
    add_column :varbinds, :metric_id, :integer
    add_column :varbinds, :varbind_type, :integer
  end
end
